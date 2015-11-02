class CardVacancyPrice < ActiveRecord::Base
  belongs_to :card
  belongs_to :vacancy
  scope :by_vacancy, ->(vacancy) { where(vacancy_id: vacancy.id) }
  validates_with VacancyPriceValidator
end