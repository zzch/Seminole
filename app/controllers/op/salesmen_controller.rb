# -*- encoding : utf-8 -*-
class Op::SalesmenController < Op::BaseController
  before_action :find_salesman, only: %w(show edit update)
  
  def index
    @salesmen = @current_club.salesmen.page(params[:page])
  end

  def show
  end
  
  def new
    @salesman = Salesman.new
  end
  
  def edit
  end
  
  def create
    @salesman = @current_club.salesmen.new(salesman_params)
    if @salesman.save
      redirect_to @salesman, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @salesman.update(salesman_params)
      redirect_to @salesman, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def salesman_params
      params.require(:salesman).permit!
    end

    def find_salesman
      @salesman = @current_club.salesmen.find(params[:id])
    end
end