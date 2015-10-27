class PlayingItem < ActiveRecord::Base
  attr_accessor :effect_all
  as_enum :charging_type, [:by_ball, :by_time], prefix: true, map: :string
  as_enum :payment_method, [:by_ball_member, :by_time_member, :unlimited_member, :stored_member, :credit_card, :cash, :check, :on_account, :signing, :coupon], prefix: true, map: :string
  belongs_to :tab
  belongs_to :vacancy
  belongs_to :member
  has_many :balls
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

  def total_balls
    self.balls.map(&:amount).reduce(:+) || 0
  end

  def total_price
    unless [:by_ball_member, :by_time_member, :unlimited_member].include?(self.payment_method)
      prefix = (Time.now.saturday? or Time.now.sunday?) ? 'holiday' : 'usual'
      if self.charging_type_by_ball?
        self.vacancy.send("#{prefix}_price_per_ball") * total_balls
      elsif self.charging_type_by_time?
        self.vacancy.send("#{prefix}_price_per_hour") * (seconds / 60 / 60)
      end
    end
  end

  def effect_all!
    self.tab.extra_items.each do |extra_item|
      extra_item.update!(payment_method: self.payment_method, member: self.member)
    end
  end

  def update_payment_method attributes
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