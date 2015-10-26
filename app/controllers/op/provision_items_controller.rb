# -*- encoding : utf-8 -*-
class Op::ProvisionItemsController < Op::BaseController
  before_action :find_provision_item, only: %w(show payment_method destroy)
  before_action :find_tab, only: %w(new create)
  
  def show
  end
  
  def new
    @provision_item = ProvisionItem.new
  end
  
  def create
    @provision_item = @tab.provision_items.new(provision_item_params)
    if @provision_item.save
      redirect_to @tab, notice: '操作成功！'
    else
      render action: 'new'
    end
  end

  def payment_method
    begin
      provision_item_params[:payment_method] = 'stored_member' unless provision_item_params[:member_id].blank?
      @provision_item.update_payment_method(provision_item_params)
      redirect_to checkout_tab_path(@provision_item.tab)
    rescue
      redirect_to checkout_tab_path(@provision_item.tab), alert: '操作失败！'
    end
  end

  def destroy
    @provision_item.destroy
    redirect_to @provision_item.tab, notice: '操作成功！'
  end

  protected
    def provision_item_params
      params.require(:provision_item).permit!
    end

    def find_provision_item
      @provision_item = @current_club.provision_items.find(params[:id])
    end

    def find_tab
      @tab = @current_club.tabs.find(params[:tab_id])
    end
end