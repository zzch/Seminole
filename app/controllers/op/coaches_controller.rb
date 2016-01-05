# -*- encoding : utf-8 -*-
class Op::CoachesController < Op::BaseController
  before_action :find_coach, only: %w(show edit update)
  
  def index
    @coaches = @current_club.coaches.order(featured: :desc)
  end
  
  def show
  end
  
  def new
    @coach = Coach.new
  end
  
  def edit
  end
  
  def create
    @coach = @current_club.coaches.new(coach_params)
    if @coach.save
      redirect_to @coach, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @coach.update(coach_params)
      redirect_to @coach, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def coach_params
      params.require(:coach).permit!
    end

    def find_coach
      @coach = @current_club.coaches.find(params[:id])
    end
end