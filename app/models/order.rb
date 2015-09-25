class Order < ActiveRecord::Base
  include UUID, AASM
  belongs_to :member
  belongs_to :operator
  has_many :line_items
  aasm column: 'state' do
    state :progressing, initial: true
    state :finished
    event :finish do
      transitions from: :progressing, to: :finished
    end
  end
end