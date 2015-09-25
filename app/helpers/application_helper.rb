# -*- encoding : utf-8 -*-
module ApplicationHelper
  def te_member_type type
    case type
    when :visitor then '临时访客'
    when :regular then '正式会员'
    end
  end

  def te_user_gender gender
    case gender
    when :male then '男'
    when :female then '女'
    end
  end
end