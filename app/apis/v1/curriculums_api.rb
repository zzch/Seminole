# -*- encoding : utf-8 -*-
module V1
  module Curriculums
    module Entities
      class Coach < Grape::Entity
        expose :name
        expose :title
        expose :portrait do |m, o|
          m.headshot.w300_h300_fl_q80.url
        end
      end

      class Course < Grape::Entity
        expose :coach, using: Curriculums::Entities::Coach
        expose :type
        expose :name
        expose :description
      end

      class Lesson < Grape::Entity
        expose :name
        with_options(format_with: :timestamp){expose :started_at}
        with_options(format_with: :timestamp){expose :finished_at}
        expose :course, using: Curriculums::Entities::Course
      end

      class List < Grape::Entity
        expose :uuid
        expose :club_name do |m, o|
          m.lesson.course.coach.club.name
        end
        expose :lesson, using: Curriculums::Entities::Lesson
        expose :rating
        expose :state
      end
    end
  end

  class CurriculumsAPI < Grape::API
    resource :curriculums do
      desc '我的课程列表'
      params do
        requires :token, type: String, desc: 'Token'
        optional :page, type: Integer, desc: '页数'
      end
      get do
        curriculums = @current_user.curriculums.order(created_at: :desc).page(params[:page])
        present curriculums, with: Curriculums::Entities::List
      end

      desc '评价我的课程'
      params do
        requires :token, type: String, desc: 'Token'
        requires :uuid, type: String, desc: '课程UUID'
        requires :score, type: Integer, desc: '分数'
      end
      get :rating do
        curriculum = @current_user.curriculums.find_uuid(params[:uuid])
        curriculum.rate(params[:score])
        present api_success
      end
    end
  end
end