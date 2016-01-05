# -*- encoding : utf-8 -*-
class Op::CoursesController < Op::BaseController
  before_action :find_course, only: %w(show edit update)
  before_action :find_coach, only: %w(new create)
  
  def index
    @courses = @current_club.courses.page(params[:page])
  end
  
  def show
  end
  
  def new
    @course = Course.new
  end
  
  def edit
  end
  
  def create
    @course = @coach.courses.new(course_params)
    if @course.save
      redirect_to @course, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @course.update(course_params)
      redirect_to @course, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  def async_show
    begin
      course = @current_club.course.find(params[:id])
      render json: AjaxMessenger.new(course)
    rescue ActiveRecord::RecordNotFound
      render json: AjaxMessenger.new('找不到课程', false)
    end
  end

  protected
    def course_params
      params.require(:course).permit!
    end

    def find_course
      @course = @current_club.courses.find(params[:id])
    end

    def find_coach
      @coach = @current_club.coaches.find(params[:coach_id])
    end
end