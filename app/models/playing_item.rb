class PlayingItem < ActiveRecord::Base
  attr_accessor :effect_all
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
    if self.payment_method_by_ball_member? or self.payment_method_by_time_member?
      0
    elsif self.payment_method_stored_member?
      if self.charging_type_by_ball?
        self.member.card.price_per_ball * self.total_balls
      elsif self.charging_type_by_time?
        ApplicationController.helpers.price_by_time(club: self.tab.club, price_per_hour: self.member.card.price_per_hour, minutes: self.minutes)
      end 
    else
      prefix = %w(6 7).include?(Time.now.day) ? 'holiday' : 'usual'
      if self.charging_type_by_ball?
        self.vacancy.send("#{prefix}_price_per_ball") * self.total_balls
      elsif self.charging_type_by_time?
        ApplicationController.helpers::price_by_time(club: self.tab.club, price_per_hour: self.vacancy.send("#{prefix}_price_per_hour"), minutes: self.minutes)
      end
    end
  end

  def effect_all!
    self.tab.extra_items.each do |extra_item|
      extra_item.update!(payment_method: self.payment_method, member: self.member)
    end
  end

  def update_payment_method attributes
    if attributes[:charging_type] == 'by_ball'
      if attributes[:member_id].blank?
        raise InvalidChargingType.new if self.vacancy.send("#{%w(6 7).include?(Time.now.day) ? 'holiday' : 'usual'}_price_per_ball").blank?
      else
        member = Member.find(attributes[:member_id])
        raise InvalidChargingType.new if member.card.type_by_time?
      end
    elsif attributes[:charging_type] == 'by_time'
      if attributes[:member_id].blank?
        raise InvalidChargingType.new if self.vacancy.send("#{%w(6 7).include?(Time.now.day) ? 'holiday' : 'usual'}_price_per_hour").blank?
      else
        member = Member.find(attributes[:member_id])
        raise InvalidChargingType.new if member.card.type_by_ball?
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