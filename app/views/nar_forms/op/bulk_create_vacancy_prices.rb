class Op::BulkCreateVacancyPrices < BaseNarForm
  attr_accessor :vacancy_ids, :mode, :usual_price_per_hour, :usual_price_per_bucket, :holiday_price_per_hour, :holiday_price_per_bucket
  validates :usual_price_per_hour, numericality: { greater_than_or_equal_to: 0 }, unless: 'usual_price_per_hour.blank?'
  validates :usual_price_per_bucket, numericality: { greater_than_or_equal_to: 0 }, unless: 'usual_price_per_bucket.blank?'
  validates :holiday_price_per_hour, numericality: { greater_than_or_equal_to: 0 }, unless: 'holiday_price_per_hour.blank?'
  validates :holiday_price_per_bucket, numericality: { greater_than_or_equal_to: 0 }, unless: 'holiday_price_per_bucket.blank?'
  validates_with VacancyPriceValidator, if: 'mode == "set"'
end