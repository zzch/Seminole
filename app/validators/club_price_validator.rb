# -*- encoding : utf-8 -*-
class ClubPriceValidator < ActiveModel::Validator

  def validate record
    record.errors[:base] << '至少填写一种价格' if record.price_per_hour.blank? and record.price_per_bucket.blank?
  end
end