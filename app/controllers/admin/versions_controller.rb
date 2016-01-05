# -*- encoding : utf-8 -*-
class Admin::VersionsController < Admin::BaseController
  
  def index
    @versions = Version.page(params[:page])
  end
  
  def show
    @version = Version.find(params[:id])
  end
  
  def new
    @version = Version.new
  end
  
  def edit
    @version = Version.find(params[:id])
  end
  
  def create
    @version = Version.new(version_params)
    if @version.save
      redirect_to [:admin, @version], notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @version = Version.find(params[:id])
    if @version.update(version_params)
      redirect_to [:admin, @version], notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def version_params
      params.require(:version).permit!
    end
end
