class PlayingItem < ActiveRecord::Base
  belongs_to :tab
  belongs_to :vacancy
  has_many :balls

  def finished?
    self.finished_at
  end

  def finish!
    raise InvalidState.new if self.finished?
    self.update!(finished_at: Time.now)
  end

  class << self
    def by_vacancy vacancy
      where(vacancy_id: vacancy.id).first
    end
  end
end