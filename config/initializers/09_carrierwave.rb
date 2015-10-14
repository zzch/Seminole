# -*- encoding : utf-8 -*-
CarrierWave.configure do |config|
  config.aliyun_access_id = Setting.key[:aliyun_oss][:access_id]
  config.aliyun_access_key = Setting.key[:aliyun_oss][:access_key]
  config.aliyun_bucket = Setting.key[:aliyun_oss][:bucket]
  config.aliyun_internal = false
  config.aliyun_area = 'cn-beijing'
end