# -*- encoding : utf-8 -*-
class Admin::ServiceExceptionsController < Admin::BaseController
  before_action :find_service_exception, only: %w(show)
  
  def index
    @service_exceptions = ServiceException.order(created_at: :desc).page(params[:page])
  end
  
  def show
  end

  protected
    def find_service_exception
      @service_exception = ServiceException.find(params[:id])
    end
end
