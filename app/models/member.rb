class Member < ActiveRecord::Base
  include UUID, AASM
  default_scope { includes(:users).includes(:card) }
  belongs_to :club
  belongs_to :card
  has_many :memberships
  has_many :users, through: :memberships
  aasm column: 'state' do
    state :activated, initial: true
    state :deactivated
  end
  scope :alphabetic, -> { joins(:user).includes(:user).order('CONVERT(users.last_name USING GBK) ASC, CONVERT(users.first_name USING GBK) ASC') }

  def holder
    memberships.select{|membership| membership.role_holder?}.first.user
  end

  class << self
    def search club, keyword
      User.where(id: club.members.map{|member| member.users.map{|user| user.id}}.flatten).where('phone LIKE ? OR CONCAT(last_name, first_name) LIKE ?', "%#{keyword}%", "%#{keyword}%").first || raise(DoesNotExist.new)
    end

    def create_with_user club, form
      ActiveRecord::Base.transaction do
        raise InvalidCard.new unless club.card_ids.include?(form.card_id.to_i)
        card = Card.find(form.card_id)
        user = User.create!(phone: form.phone.gsub(' ', '').gsub('-', ''), first_name: form.first_name, last_name: form.last_name, gender: form.gender, activated: true)
        create!(club: club, card: card, number: form.number, expired_at: Time.now + card.valid_months.months).tap {|member| member.memberships.create!(user: user, role: :holder)}
      end
    end
  end
end