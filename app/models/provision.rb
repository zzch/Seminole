class Provision < ActiveRecord::Base
  include UUID, AASM
  mount_uploader :image, ProvisionImageUploader
  belongs_to :category, class_name: 'ProvisionCategory'
  aasm column: 'state' do
    state :on_sale, initial: true
    state :discontinued
    state :out_of_stock
  end
  default_scope { includes(:category) }
  validates :name, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { greater_than: 0 }
end