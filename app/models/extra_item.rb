class ExtraItem < ActiveRecord::Base
  attr_accessor :effect_all
  as_enum :type, [:club_rental, :locker, :other], prefix: true, map: :string
  as_enum :payment_method, [:stored_member, :credit_card, :cash, :check, :on_account, :signing, :coupon], prefix: true, map: :string
  belongs_to :tab
  belongs_to :member
  has_many :member_expenses, as: :item
  after_save :effect_all?
  validates :type, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  def effect_all!
    self.tab.extra_items.each do |extra_item|
      extra_item.update!(payment_method: self.payment_method, member: self.member)
    end
  end

  def update_payment_method attributes
    attributes.merge!(member_id: nil) if attributes[:payment_method] != 'stored_member'
    self.update!(attributes)
  end

  protected
    def effect_all?
      self.tab.extra_items.each do |extra_item|
        extra_item.update!(payment_method: self.payment_method, member: self.member)
      end if self.effect_all == '1'
    end
end