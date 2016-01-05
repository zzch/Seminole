# -*- encoding : utf-8 -*-
class Op::SessionsController < Op::BaseController
  skip_before_filter :authenticate, :find_notifications
  layout null: true

  def new
    @version = Version.latest
  end

  def create
    operator = @current_club.operators.where(account: params[:account]).first.try(:authenticate, params[:password])
    unless operator.blank?
      if operator.available?
        session[:operator] = { id: operator.id, name: operator.name }
        redirect_to dashboard_path
      elsif operator.available?
        redirect_to sign_in_path, alert: '账号被禁用，无法登录'
      end
    else
      redirect_to sign_in_path, alert: '账号或密码错误，请检查后重试'
    end
  end

  def destroy
    session[:operator] = nil
    redirect_to sign_in_path
  end
end
