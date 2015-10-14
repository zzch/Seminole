class Announcement < ActiveRecord::Base
  include UUID, AASM
  belongs_to :club
  aasm column: 'state' do
    state :pending, initial: true
    state :published
    state :trashed
    event :publish do
      transitions from: :pending, to: :published
    end
    event :trash do
      transitions to: :trashed
    end
  end
end