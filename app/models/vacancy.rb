class Vacancy < ActiveRecord::Base
  include UUID, AASM
  belongs_to :club
  belongs_to :tab
  has_many :provision_items
  aasm column: 'state' do
    state :opened, initial: true
    state :closed
    state :trashed
    event :close, before: :check_before_close do
      transitions from: :opened, to: :closed
    end
    event :open do
      transitions from: :closed, to: :opened
    end
    event :trash, before: :check_before_trash do
      transitions to: :trashed
    end
  end
  scope :on_floor, ->(floor) { where(floor: floor) }
  validates :name, presence: true, length: { in: 1..10 }, uniqueness: { scope: :club_id }

  def occupied?
    self.tab
  end

  class << self
    def bulk_create form
      ActiveRecord::Base.transaction do
        (form.start_number.to_i..form.end_number.to_i).each do |number|
          find_or_create_by!(name: "#{form.prefix}#{number}#{form.suffix}", floor: form.floor)
        end
      end
    end
  end

  protected
    def check_before_close

    end

    def check_before_trash

    end
end