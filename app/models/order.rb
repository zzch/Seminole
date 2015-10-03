class Order < ActiveRecord::Base
  include UUID, AASM
  belongs_to :club
  belongs_to :user
  belongs_to :operator
  has_many :line_items
  aasm column: 'state' do
    state :progressing, initial: true
    state :cancelled
    state :finished
    event :cancel do
      transitions from: :progressing, to: :cancelled
    end
    event :finish do
      transitions from: :progressing, to: :finished
    end
  end

  class << self
    def create_by_tee attributes, tee_uuid
      ActiveRecord::Base.transaction do
        create!(attributes).tap do |order|
          Tee.lock.find_uuid(tee_uuid).tap do |tee|
            raise AlreadyInUse.new if tee.occupied?
            tee.update(order: order, played_at: Time.now)
          end
        end
      end
    end
  end
end