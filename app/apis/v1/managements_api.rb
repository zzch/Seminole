# -*- encoding : utf-8 -*-
module V1
  class ManagementsAPI < Grape::API
    before do
      # api_error_or_exception(10004)
    end

    resource :managements do
      desc '更新天气数据'
      put :update_weather do
        Weather.fetch
        present api_success
      end
    end
  end
end