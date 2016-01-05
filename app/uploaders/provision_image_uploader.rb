# -*- encoding : utf-8 -*-
class ProvisionImageUploader < BaseUploader
  version :w800_h800_fl_q80 do
    process quality: 80
    process resize_to_fill: [800, 800]
  end

  version :w150_h150_fl_q50 do
    process quality: 50
    process resize_to_fill: [150, 150]
  end
end