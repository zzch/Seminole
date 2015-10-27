class Tab < ActiveRecord::Base
  include UUID, AASM
  as_enum :confirm_method, [:app, :reception], prefix: true, map: :string
  belongs_to :club
  belongs_to :user
  belongs_to :operator
  has_many :provision_items
  has_many :playing_items
  has_many :extra_items
  has_many :vacancies
  aasm column: 'state' do
    state :progressing, initial: true
    state :cancelled
    state :finished
    event :cancel, before: :before_cancel do
      transitions from: :progressing, to: :cancelled
    end
    event :finish do
      transitions from: :progressing, to: :finished
    end
  end

  def before_cancel
    self.vacancies.each do |vacancy|
      vacancy.update(tab: nil, played_at: nil)
    end
  end

  def cash
    %w(playing provision extra).map do |type|
      self.send("#{type}_items").map do |item|
        if type == 'extra'
          (item.payment_method_cash? or item.payment_method_credit_card?) ? (item.price) : 0
        else
          (item.payment_method_cash? or item.payment_method_credit_card?) ? (item.total_price) : 0
        end
      end
    end.flatten.reduce(:+) || 0
  end

  def include_undetermined_item?
    !%w(playing provision extra).map do |type|
      self.send("#{type}_items").map do |item|
        !item.payment_method.blank?
      end
    end.flatten.all?
  end

  def confirm method
    ActiveRecord::Base.transaction do
      raise UndeterminedItem.new if self.include_undetermined_item?
      raise InvalidState.new unless self.progressing?
      self.lock!
      self.finish!
      self.update!(finished_at: Time.now)
      self.vacancies.each do |vacancy|
        vacancy.update!(tab: nil)
      end
      member_charges = {}
      self.playing_items.each do |playing_item|
        playing_item.update!(finished_at: Time.now) if playing_item.finished_at.blank?
        case playing_item.payment_method
        when :by_ball_member
          raise InvalidCardType.new unless playing_item.member.card.type_by_ball?
          raise InvalidCharingType.new unless playing_item.charging_type_by_ball?
          # raise InsufficientBall.new if playing_item.total_balls < playing_item.member.ball_amount
          # playing_item.member.update!(ball_amount: playing_item.member.ball_amount - playing_item.total_balls)
        when :by_time_member
          raise InvalidCardType.new unless playing_item.member.card.type_by_time?
          raise InvalidCharingType.new unless playing_item.charging_type_by_time?
          raise InsufficientMinute.new if (playing_item.seconds / 60) < playing_item.member.minute_amount
          # playing_item.member.update!(minute_amount: playing_item.member.minute_amount - (playing_item.seconds / 60).round)
        when :stored_member
          raise InvalidCardType.new unless playing_item.member.card.type_stored?
          raise InsufficientDeposit.new if playing_item.total_price < playing_item.member.deposit
          # playing_item.member.update!(deposit: playing_item.member.deposit - playing_item.total_price)
        end
      end
    end
  end

  class << self
    def set_up attributes, vacancy_id
      ActiveRecord::Base.transaction do
        if vacancy_id.blank?
          create!(attributes) if Tab.where(club_id: attributes[:club_id]).where(user_id: attributes[:user_id]).where(state: :progressing).first.blank?
        else
          vacancy = Vacancy.lock.find(vacancy_id)
          raise AlreadyInUse.new if vacancy.occupied?
          (Tab.lock.where(club_id: attributes[:club_id]).where(user_id: attributes[:user_id]).where(state: :progressing).first || create!(attributes)).tap do |tab|
            vacancy.update(tab: tab)
            tab.playing_items.create!(vacancy: vacancy, started_at: Time.now)
          end
        end
      end
    end
  end
end