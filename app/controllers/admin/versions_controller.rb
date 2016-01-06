# -*- encoding : utf-8 -*-
class Admin::VersionsController < Admin::BaseController
  before_action :find_version, only: %w(show edit update publish)
  
  def index
    @versions = Version.page(params[:page])
  end
  
  def show
  end
  
  def new
    @version = Version.new
  end
  
  def edit
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
    if @version.update(version_params)
      redirect_to [:admin, @version], notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  def publish
    @version.publish!
    redirect_to [:admin, @version], notice: '操作成功！'
  end

  protected
    def find_version
      @version = Version.find(params[:id])
    end

    def version_params
      params.require(:version).permit!
    end
end
