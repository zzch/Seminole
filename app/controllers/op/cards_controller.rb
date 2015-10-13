# -*- encoding : utf-8 -*-
class Op::CardsController < Op::BaseController
  before_action :find_card, only: %w(show edit update)
  
  def index
    @cards = Card.order(created_at: :desc).page(params[:page])
  end
  
  def show
  end

  def new
    @card = Card.new
  end
  
  def edit
  end

  def create
    @card = @current_club.cards.new(card_params)
    if @card.save
      redirect_to @card, notice: '创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @card.update(card_params)
      redirect_to @card, notice: '更新成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def card_params
      params.require(:card).permit!
    end

    def find_card
      @card = Card.find(params[:id])
    end
end
