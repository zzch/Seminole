class Membership < ActiveRecord::Base
  include UUID, AASM
  as_enum :role, [:holder, :user], prefix: true, map: :string
  default_scope { includes(:member) }
  belongs_to :user
  belongs_to :member
  aasm column: 'state' do
    state :activated, initial: true
    state :deactivated
  end

  def available?
    self.activated? and self.member.activated? and Time.now > self.member.expired_at
  end

  class << self
    def create_with_user member, form
      ActiveRecord::Base.transaction do
        user = User.find_or_create_member(form)
        raise DuplicatedMembership.new if member.memberships.map(&:user_id).include?(user.id)
        create!(user: user, member: member, role: :user)
      end
    end
  end
end