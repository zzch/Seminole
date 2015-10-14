# -*- encoding : utf-8 -*-
module V1
  module Courses
    module Entities
      class Detail < Grape::Entity
        expose :name
        expose :price
        expose :lessons
        expose :valid_months
        expose :maximum_students
        expose :description
      end
    end
  end

  class CoursesAPI < Grape::API
    before do
      find_current_club
    end

    resource :courses do
      desc '课程详情'
      params do
        requires :uuid, type: String, desc: '公告UUID'
      end
      get :detail do
        begin
          course = @current_club.courses.find_uuid(params[:uuid])
          present course, with: Courses::Entities::Detail
        rescue ActiveRecord::RecordNotFound
          api_error_or_exception(10001)
        end
      end
    end
  end
end
