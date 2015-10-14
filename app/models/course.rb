class Course < ActiveRecord::Base
  include UUID
  belongs_to :club
  has_many :curriculums
end