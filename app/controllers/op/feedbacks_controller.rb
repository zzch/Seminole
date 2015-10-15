# -*- encoding : utf-8 -*-
class Op::FeedbacksController < Op::BaseController
  
  def index
    @feedbacks = Feedback.latest.page(params[:page])
  end
  
  def show
    @feedback = Feedback.find(params[:id])
  end
  
  def new
    @feedback = Feedback.new
  end
  
  def edit
    @feedback = Feedback.find(params[:id])
  end
  
  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      redirect_to [:cms, @feedback], notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @feedback = Feedback.find(params[:id])
    if @feedback.update_attributes(feedback_params)
      redirect_to [:cms, @feedback], notice: '操作成功！'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.trash
    redirect_to cms_feedbacks_path, notice: '操作成功！'
  end

  protected
  def feedback_params
    params.require(:feedback).permit!
  end
end
