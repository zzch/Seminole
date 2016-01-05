# -*- encoding : utf-8 -*-
class Op::ProfilesController < Op::BaseController
  
  def edit
    @operator = @current_club.operators.find(session['operator']['id'])
  end
  
  def update
    @operator = @current_club.operators.find(session['operator']['id'])
    if @operator.update(profile_params)
      session['operator']['name'] = @operator.name
      redirect_to edit_cms_profile_path, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end
  
  def update_password
    operator = @current_club.operators.find(session['operator']['id'])
    if not operator.authenticate(params[:orginal_password])
      redirect_to edit_password_profile_path, alert: '修改失败！原密码不正确！'
    elsif not /^[A-Za-z0-9]{6,16}$/ =~ params[:new_password]
      redirect_to edit_password_profile_path, alert: '修改失败！新密码应由6至16位的大小写字母及数字组成，请重试！'
    elsif not params[:new_password] == params[:password_confirmation]
      redirect_to edit_password_profile_path, alert: '修改失败！两次新密码输入不一致！'
    else
      operator.update_password params[:new_password]
      redirect_to edit_password_profile_path, notice: '修改成功！'
    end
  end

  protected
    def profile_params
      params.require(:operator).permit(:name)
    end
end
