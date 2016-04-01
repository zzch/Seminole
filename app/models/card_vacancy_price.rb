class CardVacancyPrice < ActiveRecord::Base
  belongs_to :card
  belongs_to :vacancy
  validates_with VacancyPriceValidator

  class << self
    def by_vacancy vacancy
      where(vacancy_id: vacancy.id).first
    end
    
    def bulk_create club, card, form
      ActiveRecord::Base.transaction do
        form.vacancy_ids.each do |vacancy_id|
          vacancy = club.vacancies.find(vacancy_id)
          card_vacancy_price = find_or_initialize_by(card_id: card.id, vacancy_id: vacancy.id)
          if form.mode == 'set_price'
            card_vacancy_price.update!({ usual_price_per_hour: form.usual_price_per_hour,
              holiday_price_per_hour: form.holiday_price_per_hour,
              usual_price_per_bucket: form.usual_price_per_bucket,
              holiday_price_per_bucket: form.holiday_price_per_bucket }.select{|k, v| !v.empty?})
          elsif form.mode == 'set_discount'
            raise OriginPriceNotFound.new if (!form.usual_price_per_hour.blank? and vacancy.usual_price_per_hour.blank?) or
              (!form.holiday_price_per_hour.blank? and vacancy.holiday_price_per_hour.blank?) or
              (!form.usual_price_per_bucket.blank? and vacancy.usual_price_per_bucket.blank?) or
              (!form.holiday_price_per_bucket.blank? and vacancy.holiday_price_per_bucket.blank?)
            raise InvalidDiscount.new if (!form.usual_price_per_hour.blank? and form.usual_price_per_hour.to_d >= 10) or
              (!form.holiday_price_per_hour.blank? and form.holiday_price_per_hour.to_d >= 10) or
              (!form.usual_price_per_bucket.blank? and form.usual_price_per_bucket.to_d >= 10) or
              (!form.holiday_price_per_bucket.blank? and form.holiday_price_per_bucket.to_d >= 10)
            card_vacancy_price.update!({ usual_price_per_hour: ((form.usual_price_per_hour.blank? or vacancy.usual_price_per_hour.blank?) ? nil : (form.usual_price_per_hour.to_d * 0.1 * vacancy.usual_price_per_hour).round(form.keep_decimal? ? 2 : 0)),
              holiday_price_per_hour: ((form.holiday_price_per_hour.blank? or vacancy.holiday_price_per_hour.blank?) ? nil : (form.holiday_price_per_hour.to_d * 0.1 * vacancy.holiday_price_per_hour).round(form.keep_decimal? ? 2 : 0)),
              usual_price_per_bucket: ((form.usual_price_per_bucket.blank? or vacancy.usual_price_per_bucket.blank?) ? nil : (form.usual_price_per_bucket.to_d * 0.1 * vacancy.usual_price_per_bucket).round(form.keep_decimal? ? 2 : 0)),
              holiday_price_per_bucket: ((form.holiday_price_per_bucket.blank? or vacancy.holiday_price_per_bucket.blank?) ? nil : (form.holiday_price_per_bucket.to_d * 0.1 * vacancy.holiday_price_per_bucket).round(form.keep_decimal? ? 2 : 0)) }.select{|k, v| !v.blank?})
          end
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