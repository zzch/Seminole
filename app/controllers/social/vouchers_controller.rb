# -*- encoding : utf-8 -*-
class Social::VouchersController < Social::BaseController

  def new
    @voucher = Voucher.new
  end
  
  def create
    
  end
end