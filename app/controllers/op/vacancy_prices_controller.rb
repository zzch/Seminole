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
      begin
        if @nar_form.mode == 'set_price' or @nar_form.mode == 'set_discount'
          CardVacancyPrice.bulk_create(@current_club, @card, @nar_form)
        elsif @nar_form.mode == 'destroy'
          CardVacancyPrice.bulk_destroy(@current_club, @card, @nar_form)
        end
        redirect_to @card, notice: '操作成功！'
      rescue OriginPriceNotFound
        redirect_to bulk_new_card_vacancy_prices_path(@card), alert: '操作失败！门市价不存在！'
      rescue InvalidDiscount
        redirect_to bulk_new_card_vacancy_prices_path(@card), alert: '操作失败！折扣率不正确！'
      end
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