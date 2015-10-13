class Op::BulkCreateVacancies < BaseNarForm
  attr_accessor :prefix, :start_number, :end_number, :floor
  validates :prefix, presence: true, length: { in: 1..16 }, format: { with: /\A[A-Za-z0-9_]+\z/, message: "只能使用字母、数字和下划线" }
  validates :start_number, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :end_number, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 99 }
  validates :floor, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end