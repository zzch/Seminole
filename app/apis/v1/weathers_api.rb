# -*- encoding : utf-8 -*-
module V1
  module Weathers
    module Entities
      class Recently < Grape::Entity
        with_options(format_with: :timestamp){expose :date}
        expose :day_of_week do |m, o|
          m.date.wday
        end
        expose :content
        expose :code
        expose :maximum_temperature
        expose :probability_of_precipitation
        expose :wind
      end
    end
  end

  class WeathersAPI < Grape::API
    before do
      find_current_club
    end

    resource :weathers do
      desc '近期天气'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
      end
      get :recently do
        begin
          weahters = @current_club.weathers.recently(Time.now, 3)
          present weahters, with: Weathers::Entities::Recently
        rescue ActiveRecord::RecordNotFound
          api_error_or_exception(10001)
        end
      end
    end
  end
end