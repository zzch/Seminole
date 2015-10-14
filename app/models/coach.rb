class Coach < ActiveRecord::Base
  include UUID
  mount_uploader :portrait, CoachPortraitUploader
  as_enum :gender, [:male, :female], prefix: true, map: :string
  belongs_to :club
  has_many :curriculums
  has_many :courses, through: :curriculums
end