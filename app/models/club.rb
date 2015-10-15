class Club < ActiveRecord::Base
  include UUID
  mount_uploader :logo, ClubLogoUploader
  has_many :members
  has_many :operators
  has_many :vacancies
  has_many :cards
  has_many :provision_categories
  has_many :provisions, through: :provision_categories
  has_many :tabs
  has_many :provision_items, through: :tabs
  has_many :announcements
  has_many :coaches
  has_many :courses
  has_many :weathers
  has_many :reservations
  has_many :feedbacks
  reverse_geocoded_by :latitude, :longitude
  scope :nearest, ->(latitude, longitude) {
    near([latitude, longitude], 5000, unit: :km)
  }
  validates :name, presence: true, length: { maximum: 50 }
  validates :code, presence: true, length: { maximum: 20 }, format: { with: /\A[A-Za-z0-9\-]+\z/, message: "只能使用字母、数字和中划线" }
end