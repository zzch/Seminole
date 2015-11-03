class Member < ActiveRecord::Base
  include UUID, AASM
  default_scope { includes(:users).includes(:card) }
  belongs_to :club
  belongs_to :card
  belongs_to :salesman
  has_many :memberships
  has_many :users, through: :memberships
  has_many :expenses, class_name: 'MemberExpense'
  aasm column: 'state' do
    state :activated, initial: true
    state :deactivated
  end
  scope :by_club, ->(club) { where(club_id: club.id) }
  scope :by_ball_card, -> { includes(:card).where(cards: { type_cd: :by_ball }) }
  scope :by_time_card, -> { includes(:card).where(cards: { type_cd: :by_time }) }
  scope :unlimited_card, -> { includes(:card).where(cards: { type_cd: :unlimited }) }
  scope :stored_card, -> { includes(:card).where(cards: { type_cd: :stored }) }

  def holder
    memberships.select{|membership| membership.role_holder?}.first.user
  end

  def balance
    case self.card.type
    when :by_ball then "#{self.ball_amount}粒球"
    when :by_time then "#{self.minute_amount}分钟"
    when :unlimited then "#{remaining_valid_days}天"
    when :stored then "#{self.deposit}元"
    end
  end

  def remaining_valid_days
    ((self.expired_at - Time.now) / 86400).round.tap do |days|
      days = 0 if days < 0
    end
  end

  class << self
    def search club, keyword
      User.where(id: club.members.map{|member| member.users.map{|user| user.id}}.flatten).where('phone LIKE ? OR CONCAT(last_name, first_name) LIKE ?', "%#{keyword}%", "%#{keyword}%").first || raise(DoesNotExist.new)
    end

    def create_with_user club, form
      ActiveRecord::Base.transaction do
        raise InvalidCard.new unless club.card_ids.include?(form.card_id.to_i)
        card, user = Card.find(form.card_id), User.find_or_create_member(form)
        balance = case card.type
        when :by_ball then { ball_amount: card.ball_amount }
        when :by_time then { minute_amount: card.hour_amount * 60 }
        when :stored then { deposit: card.deposit }
        else {}
        end
        create!({ club: club, card: card, salesman_id: form.salesman_id, number: form.number, expired_at: Time.now + card.valid_months.months }.merge(balance)).tap {|member| member.memberships.create!(user: user, role: :holder)}
      end
    end
  end
end