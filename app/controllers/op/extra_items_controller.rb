# -*- encoding : utf-8 -*-
class Op::ExtraItemsController < Op::BaseController
  before_action :find_extra_item, only: %w(show payment_method destroy)
  before_action :find_tab, only: %w(new create)
  
  def show
  end
  
  def new
    @extra_item = ExtraItem.new
  end
  
  def create
    @extra_item = @tab.extra_items.new(extra_item_params)
    if @extra_item.save
      redirect_to @tab, notice: '操作成功！'
    else
      render action: 'new'
    end
  end

  def payment_method
    begin
      extra_item_params[:payment_method] = 'stored_member' unless extra_item_params[:member_id].blank?
      @extra_item.update_payment_method(extra_item_params)
      redirect_to checkout_tab_path(@extra_item.tab)
    rescue
      redirect_to checkout_tab_path(@extra_item.tab), alert: '操作失败！'
    end
  end

  def destroy
    @extra_item.destroy
    redirect_to @extra_item.tab, notice: '操作成功！'
  end

  protected
    def extra_item_params
      params.require(:extra_item).permit!
    end

    def find_extra_item
      @extra_item = @current_club.extra_items.find(params[:id])
    end

    def find_tab
      @tab = @current_club.tabs.find(params[:tab_id])
    end
end