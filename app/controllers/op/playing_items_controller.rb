# -*- encoding : utf-8 -*-
class Op::PlayingItemsController < Op::BaseController
  before_action :find_playing_item, only: %w(finish payment_method)
  
  def finish
    @playing_item.finish!
    redirect_to @playing_item.tab, notice: '操作成功！'
  end

  def payment_method
    begin
      raise InvalidParameter.new if playing_item_params[:charging_type].blank? or (playing_item_params[:payment_method].blank? and playing_item_params[:member_id].blank?)
      unless playing_item_params[:member_id].blank?
        @current_club.members.find(playing_item_params[:member_id]).tap do |member|
          raise InvalidMember.new if (member.card.type_by_ball? and playing_item_params[:charging_type] == 'by_time') or (member.card.type_by_time? and playing_item_params[:charging_type] == 'by_ball')
          playing_item_params[:payment_method] = "#{member.card.type}_member"
        end
      end
      @playing_item.update_payment_method(playing_item_params)
      redirect_to checkout_tab_path(@playing_item.tab)
    rescue ActionController::ParameterMissing, InvalidParameter
      redirect_to checkout_tab_path(@playing_item.tab), alert: '操作失败！没有选择任何付款方式！'
    rescue InvalidMember
      redirect_to checkout_tab_path(@playing_item.tab), alert: '操作失败！计费方式与会员卡类型不符！'
    end
  end

  protected
    def playing_item_params
      params.require(:playing_item).permit!
    end

    def find_playing_item
      @playing_item = @current_club.playing_items.find(params[:id])
    end
end