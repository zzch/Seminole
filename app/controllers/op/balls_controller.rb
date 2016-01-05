# -*- encoding : utf-8 -*-
class Op::BallsController < Op::BaseController

  def create
    begin
      @playing_item = PlayingItem.find(params[:playing_item_id])
      raise InvalidBucket.new if params[:bucket].to_i < 1
      @ball = @playing_item.balls.new(amount: params[:bucket].to_i * @current_club.balls_per_bucket)
      if @ball.save
        redirect_to @playing_item.tab, notice: '操作成功！'
      else
        render action: 'new'
      end
    rescue InvalidBucket
      redirect_to @playing_item.tab, alert: '操作失败！筐数不能为空！'
    end
  end
  
  def destroy
    @ball = Ball.find(params[:id])
    @ball.destroy
    redirect_to @ball.playing_item.tab, notice: '操作成功！'
  end
end