class PlayingItem < ActiveRecord::Base
  belongs_to :tab
  belongs_to :vacancy
  has_many :balls

  class << self
    def by_vacancy vacancy
      where(vacancy_id: vacancy.id).first
    end
  end
end