class PromotionImageUploader < BaseUploader
  version :w600_h200_fl_q80 do
    process quality: 80
    process resize_to_fill: [600, 200]
  end
end