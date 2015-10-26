class Op::BulkCreateVacancies < BaseNarForm
  attr_accessor :prefix, :suffix, :start_number, :end_number, :tags, :location, :usual_price_per_hour, :holiday_price_per_hour, :usual_price_per_ball, :holiday_price_per_ball
  validates :prefix, length: { maximum: 8 }, unless: 'prefix.blank?'
  validates :suffix, length: { maximum: 8 }, unless: 'suffix.blank?'
  validates :start_number, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :end_number, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 9999 }
  validates :location, presence: true
  validates_with VacancyPriceValidator
end