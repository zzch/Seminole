class Provision < ActiveRecord::Base
  include UUID, AASM
  belongs_to :category, class_name: 'ProvisionCategory'
  aasm column: 'state' do
    state :on_sale, initial: true
    state :discontinued
    state :out_of_stock
  end
  validates :name, presence: true, length: { maximum: 50 }
  validates :price, numericality: { greater_than: 0 }
end