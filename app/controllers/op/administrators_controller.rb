# -*- encoding : utf-8 -*-
class Op::AdministratorsController < Op::BaseController
  
  def index
    @administrators = Administrator.paginate page: params[:page]
  end
  
  def show
    @administrator = Administrator.find(params[:id])
  end
  
  def new
    @administrator = Administrator.new
  end
  
  def edit
    @administrator = Administrator.find(params[:id])
  end
  
  def create
    @administrator = Administrator.new(administrator_params)
    if @administrator.save
      redirect_to [:cms, @administrator], notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @administrator = Administrator.find(params[:id])
    if @administrator.update(administrator_params)
      redirect_to [:cms, @administrator], notice: '操作成功！'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @administrator = Administrator.find(params[:id])
    @administrator.trash
    redirect_to admin_administrators_path
  end

  protected
    def administrator_params
      params.require(:administrator).permit!
    end
end
