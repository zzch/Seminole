# -*- encoding : utf-8 -*-
class Op::PromotionsController < Op::BaseController
  before_action :find_promotion, only: %w(show edit update)
  
  def index
    @promotions = @current_club.promotions.page(params[:page])
  end
  
  def show
  end
  
  def new
    @promotion = Promotion.new
  end
  
  def edit
  end
  
  def create
    @promotion = @current_club.promotions.new(promotion_params)
    @promotion.published_at = Time.now
    if @promotion.save
      redirect_to @promotion, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @promotion.update(promotion_params)
      redirect_to @promotion, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def promotion_params
      params.require(:promotion).permit!
    end

    def find_promotion
      @promotion = @current_club.promotions.find(params[:id])
    end
end