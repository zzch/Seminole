# -*- encoding : utf-8 -*-
class Op::UseRightsController < Op::BaseController
  before_action :find_use_right, only: %w(show edit update)

  def new
    @use_right = UseRight.new
  end

  def create
    @use_right = @current_club.use_rights.new(use_right_params)
    if @use_right.save
      redirect_to @use_right, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @use_right.update(use_right_params)
      redirect_to @use_right, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  def destroy
    
  end

  protected
    def use_right_params
      params.require(:use_right).permit!
    end

    def find_use_right
      @use_right = @current_club.use_rights.find(params[:id])
    end
end
