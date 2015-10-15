# -*- encoding : utf-8 -*-
class Op::ProvisionsController < Op::BaseController
  before_action :find_provision, only: %w(show edit update)
  
  def index
    @provisions = @current_club.provisions.page(params[:page])
  end
  
  def show
  end
  
  def new
    @provision = Provision.new
  end
  
  def edit
  end
  
  def create
    @provision = @current_club.provisions.new(provision_params)
    if @provision.save
      redirect_to @provision, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @provision.update(provision_params)
      redirect_to @provision, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  def async_show
    begin
      provision = @current_club.provisions.find(params[:id])
      render json: AjaxMessenger.new(provision)
    rescue ActiveRecord::RecordNotFound
      render json: AjaxMessenger.new('找不到商品', false)
    end
  end

  protected
    def provision_params
      params.require(:provision).permit!
    end

    def find_provision
      @provision = @current_club.provisions.find(params[:id])
    end
end