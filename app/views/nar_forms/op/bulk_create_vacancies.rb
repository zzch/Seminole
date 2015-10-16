class Op::BulkCreateVacancies < BaseNarForm
  attr_accessor :prefix, :suffix, :start_number, :end_number, :floor
  validates :prefix, length: { maximum: 4 }, unless: 'prefix.blank?'
  validates :suffix, length: { maximum: 4 }, unless: 'suffix.blank?'
  validates :start_number, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :end_number, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 9999 }
  validates :floor, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end