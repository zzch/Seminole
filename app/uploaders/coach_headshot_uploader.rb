# -*- encoding : utf-8 -*-
class CoachHeadshotUploader < BaseUploader
  version :w300_h300_fl_q80 do
    process quality: 80
    process resize_to_fill: [300, 300]
  end
end