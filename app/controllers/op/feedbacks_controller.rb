# -*- encoding : utf-8 -*-
class Op::FeedbacksController < Op::BaseController
  
  def index
    @feedbacks = Feedback.order(created_at: :desc).page(params[:page])
  end
  
  def show
    @feedback = Feedback.find(params[:id])
  end
  
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.trash
    redirect_to cms_feedbacks_path, notice: '操作成功！'
  end
end
