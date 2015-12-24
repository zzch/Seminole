# -*- encoding : utf-8 -*-
class Op::StudentsController < Op::BaseController
  before_action :find_student, only: %w(show edit update)
  
  def index
    @students = @current_club.students.page(params[:page])
  end
  
  def show
  end
  
  def new
    @student = Student.new
  end
  
  def edit
  end
  
  def create
    @user = User.find(student_params[:user_id])
    @course = @current_club.courses.find(student_params[:course_id])
    @student = Student.new(user: @user, course: @course, price: @course.price, total_lessons: @course.maximum_lessons, expired_at: Time.now + @course.valid_months.months)
    if @student.save
      redirect_to @student, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @student.expired_at = convert_picker_to_datetime(student_params[:expired_at_date])
    if @student.update(student_params)
      redirect_to @student, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def student_params
      params.require(:student).permit!
    end

    def find_student
      @student = Student.where(course: @current_club.courses).find(params[:id])
    end
end