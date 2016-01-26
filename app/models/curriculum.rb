class Curriculum < ActiveRecord::Base
  include UUID, AASM
  belongs_to :user
  belongs_to :lesson
  aasm column: 'state' do
    state :progressing, initial: true
    state :cancelled
    state :confirming
    state :finished
    event :cancel do
      transitions from: :progressing, to: :cancelled
    end
    event :confirm do
      transitions from: :progressing, to: :confirming
    end
    event :finish do
      transitions from: :confirming, to: :finished
    end
  end

  def rate score
    self.rating = score
    self.finish
    self.save!
  end
end