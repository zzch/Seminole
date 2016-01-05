class Version < ActiveRecord::Base
  include AASM
  aasm column: 'state' do
    state :pending, initial: true
    state :published
    event :publish do
      transitions from: :pending, to: :published
    end
  end

  def name
    "#{self.major}.#{self.minor}.#{self.point}"
  end

  class << self
    def latest
      where(state: :published).order(major: :desc).order(minor: :desc).order(point: :desc).first
    end
  end
end