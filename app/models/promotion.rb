class Promotion < ActiveRecord::Base
  include UUID, AASM
  mount_uploader :image, PromotionImageUploader
  belongs_to :club
  aasm column: 'state' do
    state :pending, initial: true
    state :published
    event :publish do
      transitions from: :pending, to: :published
    end
  end
end