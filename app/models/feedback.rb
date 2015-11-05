class Feedback < ActiveRecord::Base
  include UUID
  as_enum :type, [:manager, :receiption, :restaurant], prefix: true, map: :string
  belongs_to :club
  belongs_to :user
end