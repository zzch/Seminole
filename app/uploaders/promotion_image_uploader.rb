class PromotionImageUploader < BaseUploader
  version :w640_h350_fl_q80 do
    process quality: 80
    process resize_to_fill: [640, 350]
  end
end