# -*- encoding : utf-8 -*-
class ProvisionImageUploader < BaseUploader
  version :w290_h220_fl_q80 do
    process quality: 80
    process resize_to_fill: [290, 220]
  end
end