class Curriculum < ActiveRecord::Base
  belongs_to :coach
  belongs_to :course
end