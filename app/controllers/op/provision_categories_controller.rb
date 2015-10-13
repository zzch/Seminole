# -*- encoding : utf-8 -*-
class Op::ProvisionCategoriesController < Op::BaseController
  before_action :find_provision_category, only: %w(show edit update)
  
  def index
    @provision_categories = ProvisionCategory.page(params[:page])
  end
  
  def show
  end
  
  def new
    @provision_category = ProvisionCategory.new
  end
  
  def edit
  end
  
  def create
    @provision_category = @current_club.provision_categories.new(provision_category_params)
    if @provision_category.save
      redirect_to @provision_category, notice: '创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @provision_category.update(provision_category_params)
      redirect_to @provision_category, notice: '更新成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def provision_category_params
      params.require(:provision_category).permit!
    end

    def find_provision_category
      @provision_category = ProvisionCategory.find(params[:id])
    end
end