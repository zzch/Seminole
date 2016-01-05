# -*- encoding : utf-8 -*-
class Admin::OperatorsController < Admin::BaseController
  before_action :find_club, only: %w( new create )
  
  def index
    @operators = Operator.page(params[:page])
  end
  
  def show
    @operator = Operator.find(params[:id])
  end
  
  def new
    @operator = Operator.new
  end
  
  def edit
    @operator = Operator.find(params[:id])
  end
  
  def create
    @operator = @club.operators.new(operator_params)
    if @operator.save
      redirect_to [:admin, @operator], notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @operator = Operator.find(params[:id])
    if @operator.update(operator_params)
      redirect_to [:admin, @operator], notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def operator_params
      params.require(:operator).permit!
    end

    def find_club
      @club = Club.find(params[:club_id])
    end
end
