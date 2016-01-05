class PlayingItem < ActiveRecord::Base
  attr_accessor :effect_all
  attr_accessor :started_at_date
  attr_accessor :started_at_time
  attr_accessor :finished_at_date
  attr_accessor :finished_at_time
  as_enum :charging_type, [:by_ball, :by_time], prefix: true, map: :string
  as_enum :payment_method, [:by_ball_member, :by_time_member, :unlimited_member, :stored_member, :credit_card, :cash, :check, :on_account, :signing, :coupon], prefix: true, map: :string
  belongs_to :tab
  belongs_to :vacancy
  belongs_to :member
  has_many :balls
  has_many :member_expenses, as: :item
  after_save :effect_all?

  def finished?
    self.finished_at
  end

  def finish!
    raise InvalidState.new if self.finished?
    self.update!(finished_at: Time.now)
  end

  def seconds
    (self.finished_at || Time.now) - self.started_at
  end

  def minutes
    (self.seconds / 60).round
  end

  def total_balls
    self.balls.map(&:amount).reduce(:+) || 0
  end

  def total_price
    prefix = %w(6 7).include?(Time.now.day) ? 'holiday' : 'usual'
    if self.payment_method_by_ball_member? or self.payment_method_by_time_member?
      0
    elsif self.payment_method_stored_member?
      if self.charging_type_by_ball?
        if vacancy_price = self.member.card.vacancy_prices.by_vacancy(self.vacancy)
          vacancy_price.send("#{prefix}_price_per_bucket") * self.total_balls / self.tab.club.balls_per_bucket
        elsif !self.vacancy.send("#{prefix}_price_per_bucket").blank?
          self.vacancy.send("#{prefix}_price_per_bucket") * self.total_balls / self.tab.club.balls_per_bucket
        end
      elsif self.charging_type_by_time?
        price_per_hour = (if vacancy_price = self.member.card.vacancy_prices.by_vacancy(self.vacancy).try(:send, "#{prefix}_price_per_hour")
          vacancy_price
        elsif !self.vacancy.send("#{prefix}_price_per_hour").blank?
          self.vacancy.send("#{prefix}_price_per_hour")
        end)
        ApplicationController.helpers.price_by_time(club: self.tab.club, price_per_hour: price_per_hour, minutes: self.minutes)
      end 
    else
      if self.charging_type_by_ball?
        self.vacancy.send("#{prefix}_price_per_bucket") * self.total_balls
      elsif self.charging_type_by_time?
        ApplicationController.helpers.price_by_time(club: self.tab.club, price_per_hour: self.vacancy.send("#{prefix}_price_per_hour"), minutes: self.minutes)
      end
    end
  end

  def effect_all!
    self.tab.extra_items.each do |extra_item|
      extra_item.update!(payment_method: self.payment_method, member: self.member)
    end
  end

  def update_payment_method attributes
    prefix = %w(6 7).include?(Time.now.day) ? 'holiday' : 'usual'
    member = unless attributes[:member_id].blank?
      Member.find(attributes[:member_id])
    end
    raise NoUseRights.new if member and !member.card.has_right?(self.vacancy)
    if attributes[:charging_type] == 'by_ball'
      if member.blank?
        raise NoPrice.new if self.vacancy.send("#{prefix}_price_per_bucket").blank?
      else
        raise InvalidChargingType.new if member.card.type_by_time?
        raise NoPrice.new if member.card.type_stored? and self.vacancy.send("#{prefix}_price_per_bucket").blank? and member.card.vacancy_prices.by_vacancy(self.vacancy).try(:"#{prefix}_price_per_bucket").blank?
      end
    elsif attributes[:charging_type] == 'by_time'
      if member.blank?
        raise NoPrice.new if self.vacancy.send("#{prefix}_price_per_hour").blank?
      else
        raise InvalidChargingType.new if member.card.type_by_ball?
        raise NoPrice.new if member.card.type_stored? and self.vacancy.send("#{prefix}_price_per_hour").blank? and member.card.vacancy_prices.by_vacancy(self.vacancy).try(:"#{prefix}_price_per_hour").blank?
      end
    end
    attributes.merge!(member_id: nil) unless ['by_ball_member', 'by_time_member', 'unlimited_member', 'stored_member'].include?(attributes[:payment_method])
    self.update!(attributes)
  end

  class << self
    def by_vacancy vacancy
      where(vacancy_id: vacancy.id).first
    end
  end

  protected
    def effect_all?
      self.tab.playing_items.each do |playing_item|
        playing_item.update!(charging_type: self.charging_type, payment_method: self.payment_method, member_id: self.member_id)
      end if self.effect_all == '1'
    end
end