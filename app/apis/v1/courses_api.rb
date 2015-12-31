# -*- encoding : utf-8 -*-
module V1
  module Courses
    module Entities
      class Detail < Grape::Entity
        expose :name
        expose :price
        expose :lessons do |m, o|
          m.maximum_lessons
        end
        expose :valid_months
        expose :maximum_students
        expose :description
      end

      class Coach < Grape::Entity
        expose :name
        expose :title
        expose :portrait do |m, o|
          m.portrait.w300_h400_fl_q80.url
        end
      end

      class Lessons < Grape::Entity
        expose :name
        with_options(format_with: :timestamp){expose :started_at}
        with_options(format_with: :timestamp){expose :finished_at}
        expose :current_students do |m, o|
          m.curriculums.count
        end
        expose :maximum_students
        expose :reservable do |m, o|
          m.curriculums.where(user_id: o[:current_user].id).blank?
        end
      end

      class OpenDetail < Grape::Entity
        expose :name
        expose :description
        expose :coach, using: Courses::Entities::Coach
        expose :unstarted_lessons, using: Courses::Entities::Lessons
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
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
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

    resource :open_courses do
      desc '公开课程详情'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        requires :uuid, type: String, desc: '课程UUID'
      end
      get :detail do
        begin
          course = @current_club.courses.type_opens.find_uuid(params[:uuid])
          present course, with: Courses::Entities::OpenDetail, current_user: @current_user
        rescue ActiveRecord::RecordNotFound
          api_error_or_exception(10001)
        end
      end
    end
  end
end