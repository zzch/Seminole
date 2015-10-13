class ProvisionCategory < ActiveRecord::Base
  has_many :provisions, foreign_key: 'category_id'
end