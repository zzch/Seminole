class Op::BulkCreateVacancyPrices < BaseNarForm
  attr_accessor :vacancy_ids, :mode, :keep_decimal, :usual_price_per_hour, :usual_price_per_bucket, :holiday_price_per_hour, :holiday_price_per_bucket
  validates :usual_price_per_hour, numericality: { greater_than: 0 }, unless: 'usual_price_per_hour.blank?'
  validates :usual_price_per_bucket, numericality: { greater_than: 0 }, unless: 'usual_price_per_bucket.blank?'
  validates :holiday_price_per_hour, numericality: { greater_than: 0 }, unless: 'holiday_price_per_hour.blank?'
  validates :holiday_price_per_bucket, numericality: { greater_than: 0 }, unless: 'holiday_price_per_bucket.blank?'
  validates_with VacancyPriceValidator, if: 'mode == "set_price" or mode == "set_discount"'

  def keep_decimal?
    self.keep_decimal == 'true'
  end
end