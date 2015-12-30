class Course < ActiveRecord::Base
  include UUID
  as_enum :type, [:open, :private], prefix: true, map: :string
  belongs_to :coach
  has_many :lessons
  has_many :students
  validates :type, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :valid_months, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :maximum_lessons, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :maximum_students, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end