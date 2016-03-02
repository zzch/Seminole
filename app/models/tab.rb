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
    state :confirming
    state :finished
    event :cancel, before: :before_cancel do
      transitions from: :progressing, to: :cancelled
    end
    event :check do
      transitions from: :progressing, to: :confirming
    end
    event :finish do
      transitions from: [:progressing, :confirming], to: :finished
    end
  end
  before_create :set_sequence, :set_entrance_time
  scope :by_club, ->(club) { where(club_id: club.id) }

  def before_cancel
    self.update!(departure_time: Time.now)
    self.vacancies.each do |vacancy|
      vacancy.update(tab: nil)
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

  def checking method
    ActiveRecord::Base.transaction do
      raise UndeterminedItem.new if self.include_undetermined_item?
      raise InvalidState.new unless self.progressing?
      self.lock!
      if method == :app
        self.check!
        self.update!(price: self.cash, confirm_method: :app, departure_time: Time.now)
      elsif method == :reception
        self.finish!
        self.update!(price: self.cash, confirm_method: :reception, departure_time: Time.now)
      else
        raise InvalidConfirmMethod.new
      end
      self.vacancies.each do |vacancy|
        vacancy.update!(tab: nil)
      end
      member_expenses = []
      self.playing_items.each do |playing_item|
        playing_item.update!(finished_at: Time.now) if playing_item.finished_at.blank?
        case playing_item.payment_method
        when :by_ball_member
          raise InvalidCardType.new unless playing_item.member.card.type_by_ball?
          raise InvalidCharingType.new unless playing_item.charging_type_by_ball?
          member_expenses << MemberExpense.new(member: playing_item.member, item: playing_item) if playing_item.total_balls > 0
        when :by_time_member
          raise InvalidCardType.new unless playing_item.member.card.type_by_time?
          raise InvalidCharingType.new unless playing_item.charging_type_by_time?
          member_expenses << MemberExpense.new(member: playing_item.member, item: playing_item) if ((playing_item.finished_at - playing_item.started_at) / 60) > self.club.minimum_charging_minutes
        when :stored_member
          raise InvalidCardType.new unless playing_item.member.card.type_stored?
          member_expenses << MemberExpense.new(member: playing_item.member, item: playing_item) if playing_item.total_price > 0
        end
      end
      self.provision_items.select{|provision_item| provision_item.payment_method_stored_member?}.each do |provision_item|
        raise InvalidCardType.new unless provision_item.member.card.type_stored?
        member_expenses << MemberExpense.new(member: provision_item.member, item: provision_item)
      end
      self.extra_items.select{|extra_item| extra_item.payment_method_stored_member?}.each do |extra_item|
        raise InvalidCardType.new unless extra_item.member.card.type_stored?
        member_expenses << MemberExpense.new(member: extra_item.member, item: extra_item)
      end
      member_expenses.each do |member_expense|
        member_expense.item.member.lock!
        if member_expense.item.is_a? PlayingItem
          case member_expense.item.payment_method
          when :by_ball_member
            raise InsufficientBall.new if member_expense.item.member.ball_amount < member_expense.item.total_balls
            before_ball_amount = member_expense.item.member.ball_amount
            member_expense.item.member.update!(ball_amount: before_ball_amount - member_expense.item.total_balls)
            member_expense.update!(before_amount: before_ball_amount, amount: member_expense.item.total_balls, after_amount: member_expense.item.member.ball_amount)
          when :by_time_member
            raise InsufficientMinute.new if member_expense.item.member.minute_amount < member_expense.item.minutes
            before_minute_amount = member_expense.item.member.minute_amount
            member_expense.item.member.update!(minute_amount: member_expense.item.member.minute_amount - member_expense.item.minutes)
            member_expense.update!(before_amount: before_minute_amount, amount: member_expense.item.total_balls, after_amount: member_expense.item.member.minute_amount)
          when :stored_member
            raise InsufficientDeposit.new if member_expense.item.member.deposit < member_expense.item.total_price
            before_deposit = member_expense.item.member.deposit
            member_expense.item.member.update!(deposit: member_expense.item.member.deposit - member_expense.item.total_price)
            member_expense.update!(before_amount: before_deposit, amount: member_expense.item.total_price, after_amount: member_expense.item.member.deposit)
          end
        elsif member_expense.item.is_a? ProvisionItem
          raise InsufficientDeposit.new if member_expense.item.member.deposit < member_expense.item.total_price
          before_deposit = member_expense.item.member.deposit
          member_expense.item.member.update!(deposit: member_expense.item.member.deposit - member_expense.item.total_price)
          member_expense.update!(before_amount: before_deposit, amount: member_expense.item.total_price, after_amount: member_expense.item.member.deposit)
        elsif member_expense.item.is_a? ExtraItem
          raise InsufficientDeposit.new if member_expense.item.member.deposit < member_expense.item.price
          before_deposit = member_expense.item.member.deposit
          member_expense.item.member.update!(deposit: member_expense.item.member.deposit - member_expense.item.price)
          member_expense.update!(before_amount: before_deposit, amount: member_expense.item.price, after_amount: member_expense.item.member.deposit)
        else
          raise InvalidItem.new
        end
      end
      if method == :app
        Thread.new do
          push_content = { notification: { ios: { alert: '您有一笔消费单需要确认', extras: { redirect_to: :tabs_list, club_uuid: self.club.uuid } }, android: { alert: '您有一笔消费单需要确认', extras: { redirect_to: :tabs_list, club_uuid: self.club.uuid } } } }
          self.user.send_push(push_content) unless self.user.registration_id.blank?
        end
      end
    end
  end

  def confirm
    begin
      self.finish!
    rescue AASM::InvalidTransition
      raise InvalidState.new
    end
  end

  class << self
    def set_up attributes, vacancy_ids
      ActiveRecord::Base.transaction do
        if vacancy_ids.blank?
          Tab.where(club_id: attributes[:club_id]).where(user_id: attributes[:user_id]).where(state: :progressing).first || create!(attributes)
        else
          vacancies = Club.find(attributes[:club_id]).vacancies.lock.find(vacancy_ids.split(','))
          raise AlreadyInUse.new if vacancies.map(&:occupied?).any?
          (Tab.lock.where(club_id: attributes[:club_id]).where(user_id: attributes[:user_id]).where(state: :progressing).first || create!(attributes)).tap do |tab|
            vacancies.each do |vacancy|
              vacancy.update(tab: tab)
              tab.playing_items.create!(vacancy: vacancy, started_at: Time.now)
            end
          end
        end
      end
    end

    def search conditions
      tab = Tab.order(created_at: :desc)
      tab = tab.where('entrance_time >= ?', conditions[:started_at].to_time.beginning_of_day) unless conditions[:started_at].blank?
      tab = tab.where('entrance_time <= ?', conditions[:end_at].to_time.end_of_day) unless conditions[:end_at].blank?
      tab
    end
  end
  
  protected
    def set_sequence
      self.sequence = (Tab.where(club_id: self.club_id).maximum(:sequence) || 0) + 1
    end

    def set_entrance_time
      self.entrance_time ||= Time.now
    end
end