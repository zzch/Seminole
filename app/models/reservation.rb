class Reservation < ActiveRecord::Base
  include AASM
  attr_accessor :will_playing_at_date
  attr_accessor :will_playing_at_time
  belongs_to :club
  belongs_to :user
  belongs_to :vacancy
  before_create :can_be_created?
  aasm column: 'state' do
    state :submitted, initial: true
    state :confirmed
    state :cancelled
    state :finished
    event :confirm do
      transitions from: :submited, to: :confirmed
    end
    event :finish do
      transitions from: :confirmed, to: :finished
    end
  end
  scope :by_club, ->(club) { where(club_id: club.id) }
  validates :club, presence: true
  validates :user, presence: true

  protected
    def can_be_created?
      raise DuplicatedReservation.new if Reservation.where(club_id: self.club_id, user_id: self.user_id).where('will_playing_at >= ?', self.will_playing_at.beginning_of_day).where('will_playing_at <= ?', self.will_playing_at.end_of_day).first
    end
end