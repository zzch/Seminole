# -*- encoding : utf-8 -*-
module ApplicationHelper
  def te_user_gender gender
    case gender
    when :male then '男'
    when :female then '女'
    end
  end

  def te_membership_role role
    case role
    when :holder then '持卡人'
    when :user then '使用者'
    end
  end

  def te_card_type type
    case type
    when :by_ball then '计球卡'
    when :by_time then '计时卡'
    when :unlimited then '畅打卡'
    when :stored then '储值卡'
    end
  end

  def te_provision_item_type type
    case type
    when :primary then '打球消费'
    when :secondary then '其它消费'
    end
  end

  def user_options_for_set_up_tab
    User.where(id: Membership.where(member_id: Club.last.member_ids).map(&:user_id).uniq).map{|user| ["#{PinYin.abbr(user.name).upcase} | #{user.name} | #{user.phone}", user.id]}
  end
end