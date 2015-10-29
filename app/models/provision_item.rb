class ProvisionItem < ActiveRecord::Base
  attr_accessor :effect_all
  as_enum :payment_method, [:stored_member, :credit_card, :cash, :check, :on_account, :signing, :coupon], prefix: true, map: :string
  before_save :set_price
  after_save :effect_all?
  belongs_to :tab
  belongs_to :provision
  belongs_to :member
  has_many :member_expenses, as: :item
  default_scope { includes(:provision) }
  validates :provision, presence: true
  validates :quantity, presence: true

  def total_price
    self.price * self.quantity
  end

  def effect_all!
    self.tab.provision_items.each do |provision_item|
      provision_item.update!(payment_method: self.payment_method, member: self.member)
    end
  end

  def update_payment_method attributes
    attributes.merge!(member_id: nil) if attributes[:payment_method] != 'stored_member'
    self.update!(attributes)
  end

  protected
    def set_price
      self.price = self.provision.price
    end

    def effect_all?
      self.tab.provision_items.each do |provision_item|
        provision_item.update!(payment_method: self.payment_method, member: self.member)
      end if self.effect_all == '1'
    end
end