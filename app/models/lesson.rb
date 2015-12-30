class Lesson < ActiveRecord::Base
  include UUID
  attr_accessor :started_at_date
  attr_accessor :started_at_time
  attr_accessor :finished_at_date
  attr_accessor :finished_at_time
  belongs_to :course
  validates :started_at, presence: true
  validates :finished_at, presence: true
  validates :maximum_students, presence: true, numericality: { only_integer: true }
end