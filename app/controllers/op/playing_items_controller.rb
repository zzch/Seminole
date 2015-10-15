# -*- encoding : utf-8 -*-
class Op::PlayingItemsController < Op::BaseController
  before_action :find_playing_item, only: %w(finish)
  
  def finish
    @playing_item.finish!
    redirect_to @playing_item.tab, notice: '操作成功！'
  end

  protected
    def find_playing_item
      @playing_item = PlayingItem.find(params[:id])
    end
end
