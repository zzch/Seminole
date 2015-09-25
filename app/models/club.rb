class Club < ActiveRecord::Base
  include UUID
  has_many :members
  has_many :operators
  has_many :tees
  has_many :product_categories
  has_many :orders
  validates :name, presence: true, length: { maximum: 50 }
  validates :code, presence: true, length: { maximum: 20 }, format: { with: /\A[A-Za-z0-9\-]+\z/, message: "只能使用字母、数字和中划线" }
end