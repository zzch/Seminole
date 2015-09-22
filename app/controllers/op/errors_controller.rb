# -*- encoding : utf-8 -*-
class Op::ErrorsController < Op::BaseController
  
  def index
    @errors = Error.sorted.paginate page: params[:page]
  end
  
  def show
    @error = Error.find(params[:id])
  end
  
  def destroy
    @error = Error.find(params[:id])
    @error.destroy
    redirect_to cms_errors_path
  end
end
