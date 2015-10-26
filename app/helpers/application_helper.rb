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
    when :visitor then '访客卡'
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

  def te_vacancy_location location
    case location
    when :first_floor then '1F'
    when :second_floor then '2F'
    when :third_floor then '3F'
    when :green then '果岭'
    when :simulator then '模拟器'
    end
  end

  def te_extra_item_type type
    case type
    when :club_rental then '租杆费'
    when :locker then '存包费'
    when :other then '其它'
    end
  end

  def user_options_for_set_up_tab
    User.where(id: Membership.where(member_id: @current_club.member_ids).map(&:user_id).uniq).map{|user| ["#{PinYin.abbr(user.name).upcase} | #{user.name} | #{user.phone}", user.id]}
  end

  def salesmen_options
    @current_club.salesmen.map{|salesman| ["#{PinYin.abbr(salesman.name).upcase} | #{salesman.name}", salesman.id]}
  end

  def extra_item_type_options
    ExtraItem.types.keys.map do |type|
      [(case type
      when 'club_rental' then '租杆费'
      when 'locker' then '存包费'
      when 'other' then '其它'
      end), type]
    end
  end

  def card_type_options
    Card.types.keys.map do |type|
      [(case type
      when 'by_ball' then '计球卡'
      when 'by_time' then '计时卡'
      when 'unlimited' then '畅打卡'
      when 'stored' then '储值卡'
      end), type]
    end
  end

  def vacancy_location_options
    Vacancy.locations.keys.map do |location|
      [(case location
      when 'first_floor' then '1F'
      when 'second_floor' then '2F'
      when 'third_floor' then '3F'
      when 'green' then '果岭'
      when 'simulator' then '模拟器'
      end), location]
    end
  end

  def vacancy_tags tags
    raw tags.map{|tag| "<span class=\"label label-success\">#{tag.name}</span>"}.join(' ')
  end

  def payment_method_tag item
    if item.payment_method.blank?
      '请选择'
    else
      raw('<span class="label label-primary">' +
      if item.try(:payment_method_by_ball_member?)
        '计球卡'
      elsif item.try(:payment_method_by_time_member?)
        '计时卡'
      elsif item.try(:payment_method_unlimited_member?)
        '畅打卡'
      elsif item.payment_method_stored_member?
        '储值卡'
      elsif item.payment_method_credit_card?
        '信用卡'
      elsif item.payment_method_cash?
        '现金'
      elsif item.payment_method_check?
        '支票'
      elsif item.payment_method_on_account?
        '挂账'
      elsif item.payment_method_signing?
        '签单'
      elsif item.payment_method_coupon?
        '抵用卷'
      end + '</span>')
    end
  end
end