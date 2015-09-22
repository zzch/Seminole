# -*- encoding : utf-8 -*-
class Admin::SessionsController < Admin::BaseController
  skip_before_filter :authenticate
  layout null: true

  def create
    administrator = Administrator.where(account: params[:account]).first.try(:authenticate, params[:password])
    unless administrator.blank?
      if administrator.available?
        session[:administrator] = { id: administrator.id, name: administrator.name }
        redirect_to admin_dashboard_path
      elsif administrator.available?
        redirect_to admin_sign_in_path, alert: '账号被禁用，无法登录'
      end
    else
      redirect_to admin_sign_in_path, alert: '账号或密码错误，请检查后重试'
    end
  end

  def destroy
    session[:administrator] = nil
    redirect_to admin_sign_in_path
  end
end
