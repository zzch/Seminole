# -*- encoding : utf-8 -*-
class Op::TeesController < Op::BaseController
  before_action :find_tee, only: %w(show edit update open close)
  
  def index
    @tees = Tee.page(params[:page])
  end
  
  def show
  end
  
  def new
    @tee = Tee.new
  end
  
  def edit
  end
  
  def create
    @tee = @current_club.tees.new(tee_params)
    if @tee.save
      redirect_to @tee, notice: '创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @tee.update(tee_params)
      redirect_to @tee, notice: '更新成功！'
    else
      render action: 'edit'
    end
  end

  def bulk_new
    @nar_form = Op::BulkCreateTees.new
  end

  def bulk_create
    @nar_form = Op::BulkCreateTees.new(params[:op_bulk_create_tees])
    if @nar_form.valid?
      @current_club.tees.bulk_create(@nar_form)
      redirect_to tees_path, notice: '创建成功！'
    else
      render action: 'bulk_new'
    end
  end

  def open
    begin
      @tee.open!
      redirect_to @tee, notice: '操作成功！'
    rescue AASM::InvalidTransition
      redirect_to @tee, alert: '无效的状态！'
    end
  end

  def close
    begin
      @tee.close!
      redirect_to @tee, notice: '操作成功！'
    rescue AASM::InvalidTransition
      redirect_to @tee, alert: '无效的状态！'
    end
  end

  protected
    def tee_params
      params.require(:tee).permit!
    end

    def find_tee
      @tee = Tee.find(params[:id])
    end
end