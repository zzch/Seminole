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
    @tee = @current_club.tees.find(params[:tee_id]) if params[:tee_id]
    @nar_form = Op::CreateOrderWithVisitor.new
  end
  
  def edit
  end
  
  def create
    begin
      @order = Order.create_by_tee(order_params.merge({ club_id: @current_club.id, operator_id: session['operator']['id'] }), params[:tee_uuid])
      redirect_to @order, notice: '创建成功！'
    rescue AlreadyInUse
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