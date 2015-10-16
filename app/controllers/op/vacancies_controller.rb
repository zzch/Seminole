# -*- encoding : utf-8 -*-
class Op::VacanciesController < Op::BaseController
  before_action :find_vacancy, only: %w(show edit update open close)
  
  def index
    @vacancies = @current_club.vacancies.page(params[:page])
  end
  
  def show
  end
  
  def new
    @vacancy = Vacancy.new
  end
  
  def edit
  end
  
  def create
    @vacancy = @current_club.vacancies.new(vacancy_params)
    if @vacancy.save
      redirect_to @vacancy, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @vacancy.update(vacancy_params)
      redirect_to @vacancy, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  def bulk_new
    @nar_form = Op::BulkCreateVacancies.new
  end

  def bulk_create
    @nar_form = Op::BulkCreateVacancies.new(params[:op_bulk_create_vacancies])
    if @nar_form.valid?
      @current_club.vacancies.bulk_create(@nar_form)
      redirect_to vacancies_path, notice: '操作成功！'
    else
      render action: 'bulk_new'
    end
  end

  def open
    begin
      @vacancy.open!
      redirect_to @vacancy, notice: '操作成功！'
    rescue AASM::InvalidTransition
      redirect_to @vacancy, alert: '无效的状态！'
    end
  end

  def close
    begin
      @vacancy.close!
      redirect_to @vacancy, notice: '操作成功！'
    rescue AASM::InvalidTransition
      redirect_to @vacancy, alert: '无效的状态！'
    end
  end

  protected
    def vacancy_params
      params.require(:vacancy).permit!
    end

    def find_vacancy
      @vacancy = @current_club.vacancies.find(params[:id])
    end
end