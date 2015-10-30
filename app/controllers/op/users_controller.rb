# -*- encoding : utf-8 -*-
class Op::UsersController < Op::BaseController
  before_action :find_user, only: %w(show edit update)
  
  def index
    @users = User.where(id: @current_club.memberships.map(&:user_id).uniq).order(created_at: :desc).page(params[:page])
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to @user, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def user_params
      params.require(:user).permit!
    end

    def find_user
      @user = User.where(id: @current_club.memberships.map(&:user_id).uniq).find(params[:id])
    end
end