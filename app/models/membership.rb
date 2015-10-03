class Membership < ActiveRecord::Base
  include UUID, AASM
  as_enum :role, [:owner, :user], prefix: true, map: :string
  belongs_to :user
  belongs_to :member
  aasm column: 'state' do
    state :activated, initial: true
    state :deactivated
  end
end