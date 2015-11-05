class Reservation < ActiveRecord::Base
  include AASM
  belongs_to :club
  belongs_to :user
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

  protected
    def can_be_created?
      raise DuplicatedReservation.new if Reservation.where(club_id: self.club_id, user_id: self.user_id).where('will_playing_at >= ?', self.will_playing_at.beginning_of_day).where('will_playing_at <= ?', self.will_playing_at.end_of_day).first
    end
end