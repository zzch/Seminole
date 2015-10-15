# -*- encoding : utf-8 -*-
module V1
  module Coaches
    module Entities
      class Courses < Grape::Entity
        expose :uuid
        expose :name
        expose :price
        expose :lessons
      end

      class List < Grape::Entity
        expose :uuid
        expose :name
        expose :portrait do |m, o|
          m.portrait.w300_h400_fl_q80.url
        end
        expose :gender
        expose :title
        expose :featured
      end

      class Detail < Grape::Entity
        expose :name
        expose :portrait do |m, o|
          m.portrait.w300_h400_fl_q80.url
        end
        expose :gender
        expose :title
        expose :description
        expose :courses, using: Coaches::Entities::Courses
      end
    end
  end

  class CoachesAPI < Grape::API
    before do
      find_current_club
    end

    resource :coaches do
      desc '教练列表'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        optional :page, type: Integer, desc: '页码'
      end
      get do
        coaches = @current_club.coaches.order(featured: :desc)
        present coaches, with: Coaches::Entities::List
      end

      desc '教练详情'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        requires :uuid, type: String, desc: '公告UUID'
      end
      get :detail do
        begin
          coach = @current_club.coaches.find_uuid(params[:uuid])
          present coach, with: Coaches::Entities::Detail
        rescue ActiveRecord::RecordNotFound
          api_error_or_exception(10001)
        end
      end
    end
  end
end