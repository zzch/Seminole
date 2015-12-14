# encoding: utf-8
class CkeditorPictureUploader < BaseUploader
  include Ckeditor::Backend::CarrierWave
  process :read_dimensions

  version :content do
    process :resize_to_limit => [800, 600]
  end
end