# -*- encoding : utf-8 -*-
class Op::LessonsController < Op::BaseController
  before_action :find_lesson, only: %w(show edit update)
  before_action :find_course, only: %w(new create)
  
  def index
    @lessons = @current_club.lessons.page(params[:page])
  end
  
  def show
  end
  
  def new
    @lesson = Lesson.new
  end
  
  def edit
  end
  
  def create
    @lesson = @course.lessons.new(lesson_params)
    @lesson.started_at = convert_picker_to_datetime(lesson_params[:started_at_date], lesson_params[:started_at_time])
    @lesson.finished_at = convert_picker_to_datetime(lesson_params[:finished_at_date], lesson_params[:finished_at_time])
    if @lesson.save
      redirect_to @lesson, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @lesson.update(lesson_params)
      redirect_to @lesson, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  def async_show
    begin
      lesson = @current_club.lessons.find(params[:id])
      render json: AjaxMessenger.new(lesson)
    rescue ActiveRecord::RecordNotFound
      render json: AjaxMessenger.new('找不到商品', false)
    end
  end

  protected
    def lesson_params
      params.require(:lesson).permit!
    end

    def find_lesson
      @lesson = Lesson.where(course_id: @current_club.courses.map(&:id)).find(params[:id])
    end

    def find_course
      @course = @current_club.courses.find(params[:course_id])
    end
end