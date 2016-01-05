class Salesman < ActiveRecord::Base
  include UUID
  belongs_to :club
  has_many :members
end