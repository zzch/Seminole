# -*- encoding : utf-8 -*-
class Op::OrdersController < Op::BaseController
  before_action :find_order, only: %w(show edit update)
  
  def index
    @orders = Order.page(params[:page])
  end
  
  def show
  end
  
  def new
    @order = Order.new
    @tee = Tee.find_uuid(params[:tee_uuid]) if params[:tee_uuid]
    @members = @current_club.members.alphabetic
  end
  
  def edit
  end
  
  def create
    @order = @current_club.orders.new(order_params)
    @order.operator_id = session['operator']['id']
    if @order.save
      redirect_to @order, notice: '创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @order.update(order_params)
      redirect_to @order, notice: '更新成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def order_params
      params.require(:order).permit!
    end

    def find_order
      @order = Order.find(params[:id])
    end
end