# -*- encoding : utf-8 -*-
class VacancyPriceValidator < ActiveModel::Validator

  def validate record
    record.errors[:base] << '至少填写一种计费方式' if !(!record.usual_price_per_hour.blank? and !record.holiday_price_per_hour.blank?) and !(!record.usual_price_per_bucket.blank? and !record.holiday_price_per_bucket.blank?)
  end
end