# -*- encoding : utf-8 -*-
class Op::BallsController < Op::BaseController

  def create
    @playing_item = PlayingItem.find(params[:playing_item_id])
    @ball = @playing_item.balls.new(amount: params[:amount])
    if @ball.save
      redirect_to @playing_item.tab, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def destroy
    @ball = Ball.find(params[:id])
    @ball.destroy
    redirect_to @ball.playing_item.tab, notice: '操作成功！'
  end
end