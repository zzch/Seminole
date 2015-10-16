class Card < ActiveRecord::Base
  include UUID
  belongs_to :club
  as_enum :type, [:visitor, :by_ball, :by_time, :unlimited, :stored], prefix: true, map: :string
end