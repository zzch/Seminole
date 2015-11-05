# -*- encoding : utf-8 -*-
class Op::VacancyPricesController < Op::BaseController
  before_action :find_card, only: %w(bulk_new bulk_create)

  def bulk_new
    @nar_form = Op::BulkCreateVacancyPrices.new
  end

  def bulk_create
    params[:op_bulk_create_vacancy_prices][:vacancy_ids].reject!{|vacancy_id| vacancy_id.to_i.zero?}
    @nar_form = Op::BulkCreateVacancyPrices.new(params[:op_bulk_create_vacancy_prices])
    if @nar_form.valid?
      if @nar_form.mode == 'set'
        CardVacancyPrice.bulk_create(@current_club, @card, @nar_form)
      elsif @nar_form.mode == 'destroy'
        CardVacancyPrice.bulk_destroy(@current_club, @card, @nar_form)
      end
      redirect_to @card, notice: '操作成功！'
    else
      render action: 'bulk_new'
    end
  end
  
  def destroy
    @vacancy_price = VacancyPrice.find(params[:id])
    @vacancy_price.destroy
    redirect_to @vacancy_price.playing_item.tab, notice: '操作成功！'
  end

  protected
    def find_card
      @card = @current_club.cards.find(params[:card_id])
    end
end