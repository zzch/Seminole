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
    begin
      raise NonUniqueMember.new if @user.members.map{|member| member.club_id}.uniq.count > 1
      user_params[:phone].gsub!(/[ -]/, '')
      if @user.update(user_params)
        redirect_to @user, notice: '操作成功！'
      else
        render action: 'edit'
      end
    rescue NonUniqueMember
      redirect_to @user, alert: '操作失败！该用户存在其它球场信息！请联系管理员进行修改！'
    end
  end

  def initial
    @users = User.where(id: @current_club.memberships.map(&:user_id).uniq).order(created_at: :desc).select{|user| PinYin.abbr(user.name)[0] == params[:letter]}
  end

  def async_uniqueness_check
    user = User.where(phone: params[:phone]).first
    if user.blank?
      render json: { found: false }
    else
      render json: { found: true, first_name: user.first_name, last_name: user.last_name, gender: user.gender }
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