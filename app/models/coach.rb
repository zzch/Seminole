class Coach < ActiveRecord::Base
  include UUID
  mount_uploader :portrait, CoachPortraitUploader
  as_enum :gender, [:male, :female], prefix: true, map: :string
  belongs_to :club
  has_many :courses
  scope :featured, -> { where(featured: true) }
  scope :normal, -> { where(featured: false) }
  validates :phone, format: { with: /\A1[0-9]{10}\z/, message: "格式无效" }, unless: 'phone.blank?'
  validates :name, presence: true, length: { maximum: 50 }
  validates :gender, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :starting_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end