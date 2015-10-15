class Feedback < ActiveRecord::Base
  include UUID
  belongs_to :club
  belongs_to :user
end