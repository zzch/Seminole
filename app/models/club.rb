class Club < ActiveRecord::Base
  include UUID
  mount_uploader :logo, ClubLogoUploader
  reverse_geocoded_by :latitude, :longitude
  has_many :members
  has_many :operators
  has_many :vacancies
  has_many :cards
  has_many :provision_categories
  has_many :provisions, through: :provision_categories
  has_many :tabs
  has_many :provision_items, through: :tabs
  has_many :playing_items, through: :tabs
  has_many :extra_items, through: :tabs
  has_many :announcements
  has_many :coaches
  has_many :courses
  has_many :weathers
  has_many :reservations
  has_many :feedbacks
  has_many :salesmen
  has_many :vacancy_tags
  scope :nearest, ->(latitude, longitude) {
    near([latitude, longitude], 5000, unit: :km)
  }
  validates :name, presence: true, length: { maximum: 50 }
  validates :code, presence: true, length: { maximum: 20 }, format: { with: /\A[A-Za-z0-9\-]+\z/, message: "只能使用字母、数字和中划线" }
  validates :floors, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3 }
  validates :longitude, presence: true, numericality: true
  validates :latitude, presence: true, numericality: true
  validates :address, length: { maximum: 400 }
end