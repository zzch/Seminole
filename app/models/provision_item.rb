class ProvisionItem < ActiveRecord::Base
  belongs_to :tab
  belongs_to :provision
  before_save :set_price
  default_scope { includes(:provision) }

  def total_price
    self.price * self.quantity
  end

  protected
    def set_price
      self.price = self.provision.price
    end
end