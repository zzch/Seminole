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
end