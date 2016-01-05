# -*- encoding : utf-8 -*-
class Op::CardsController < Op::BaseController
  before_action :find_card, only: %w(show edit update destroy)
  
  def index
    @cards = @current_club.cards.order(created_at: :desc).page(params[:page])
  end
  
  def show
    @card_vacancy_prices = Hash[@card.vacancy_prices.map{|vacancy_price| [vacancy_price.vacancy_id, vacancy_price]}] if @card.type_stored?
  end

  def new
    @card = Card.new
  end
  
  def edit
  end

  def create
    @card = @current_club.cards.new(card_params)
    if @card.save
      @card.reset_use_rights_by_vacancy_tag_ids
      redirect_to @card, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @card.update(card_params)
      @card.reset_use_rights_by_vacancy_tag_ids
      redirect_to @card, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  def destroy
    begin
      @card.destroy
      redirect_to cards_path, notice: '操作成功！'
    rescue MemberExists
      redirect_to @card, alert: '操作失败！已存在会籍！'
    end
  end

  protected
    def card_params
      params.require(:card).permit!
    end

    def find_card
      @card = @current_club.cards.find(params[:id])
    end
end
