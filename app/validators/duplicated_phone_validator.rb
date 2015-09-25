# -*- encoding : utf-8 -*-
class DuplicatedPhoneValidator < ActiveModel::Validator

  def validate record
    unless record.phone.blank?
      record.errors[:phone] << '已被注册' if User.where(phone: record.phone.gsub(' ', '').gsub('-', '')).first
    end
  end
end
