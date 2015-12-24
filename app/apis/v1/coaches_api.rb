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

      class Course < Grape::Entity
        expose :uuid
        expose :name
        expose :portrait do |m, o|
          m.portrait.w300_h400_fl_q80.url
        end
        expose :gender
        expose :title
        expose :starting_price
        expose :description
      end

      class Student < Grape::Entity
        expose :uuid
        expose :course do |m, o|
          { name: m.course.name, type: m.course.type }
        end
        expose :total_lessons
        with_options(format_with: :timestamp){expose :expired_at}
      end

      class List < Grape::Entity
        expose :students, using: Coaches::Entities::Student
        expose :featured, using: Coaches::Entities::Course
        expose :normal, using: Coaches::Entities::Course
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
        featured_coaches = @current_club.coaches.select{|coach| coach.featured?}
        normal_coaches = @current_club.coaches.select{|coach| !coach.featured?}
        list = { featured: featured_coaches, normal: normal_coaches }
        present list, with: Coaches::Entities::List
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

    resource :students_and_coaches do
      desc '课程及教练列表'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        optional :page, type: Integer, desc: '页码'
      end
      get do
        students = @current_user.students.progressing
        featured_coaches = @current_club.coaches.select{|coach| coach.featured?}
        normal_coaches = @current_club.coaches.select{|coach| !coach.featured?}
        list = { students: students, featured: featured_coaches, normal: normal_coaches }
        present list, with: Coaches::Entities::List
      end
    end
  end
end