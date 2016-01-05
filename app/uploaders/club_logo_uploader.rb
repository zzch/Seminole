# -*- encoding : utf-8 -*-
class ClubLogoUploader < BaseUploader
  version :w600_h600_fl_q80 do
    process quality: 80
    process resize_to_fill: [600, 600]
  end

  version :w150_h150_fl_q50 do
    process quality: 50
    process resize_to_fill: [150, 150]
  end
end