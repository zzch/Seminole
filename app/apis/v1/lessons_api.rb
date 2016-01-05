# -*- encoding : utf-8 -*-
module V1
  class LessonsAPI < Grape::API
    before do
      find_current_club
    end

    resource :lessons do
      desc '近期天气'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        requires :uuid, type: String, desc: '课时UUID'
      end
      put :reserve do
        begin
          lesson = @current_club.lessons.find_uuid(params[:uuid])
          present api_success
        rescue ActiveRecord::RecordNotFound
          api_error_or_exception(10001)
        end
      end
    end
  end
end