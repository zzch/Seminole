class ProductCategory < ActiveRecord::Base
  has_many :products, foreign_key: 'category_id'
end