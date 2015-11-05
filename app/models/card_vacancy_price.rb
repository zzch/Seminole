class CardVacancyPrice < ActiveRecord::Base
  belongs_to :card
  belongs_to :vacancy
  scope :by_vacancy, ->(vacancy) { where(vacancy_id: vacancy.id) }
  validates_with VacancyPriceValidator

  class << self
    def bulk_create club, card, form
      ActiveRecord::Base.transaction do
        form.vacancy_ids.each do |vacancy_id|
          card_vacancy_price = find_or_initialize_by(card_id: card.id, vacancy_id: club.vacancies.find(vacancy_id).id)
          card_vacancy_price.update!(usual_price_per_hour: form.usual_price_per_hour, holiday_price_per_hour: form.holiday_price_per_hour, usual_price_per_bucket: form.usual_price_per_bucket, holiday_price_per_bucket: form.holiday_price_per_bucket)
        end
      end
    end

    def bulk_destroy club, card, form
      vacancy_ids = form.vacancy_ids.map do |vacancy_id|
        club.vacancies.find(vacancy_id).id
      end
      where(card_id: card.id, vacancy_id: vacancy_ids).destroy_all
    end
  end
end