class Product < ActiveRecord::Base
  include AASM
  belongs_to :product_category
  aasm column: 'state' do
    state :on_sale, initial: true
    state :discontinued
    state :out_of_stock
  end
end