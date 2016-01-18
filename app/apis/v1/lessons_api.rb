# -*- encoding : utf-8 -*-
module V1
  class LessonsAPI < Grape::API
    before do
      find_current_club
    end

    resource :lessons do
      desc '预约公开课'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        requires :uuid, type: String, desc: '课时UUID'
      end
      post :reserve_open do
        begin
          lesson = Lesson.where(course_id: @current_club.courses.map(&:id)).find_uuid(params[:uuid])
          lesson.reserve_open(@current_user)
          present api_success
        rescue ActiveRecord::RecordNotFound
          api_error_or_exception(10001)
        rescue PermissionDenied
          api_error_or_exception(10004)
        rescue FullLesson
          api_error_or_exception(20006)
        rescue DuplicatedReservation
          api_error_or_exception(20004)
        end
      end

      desc '预约私教课'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        requires :course_uuid, type: String, desc: '课程UUID'
        requires :reserved_at, type: Integer, desc: '预约时间'
      end
      post :reserve_private do
        begin
          course = @current_club.courses.find_uuid(params[:course_uuid])
          Lesson.reserve_private(course: course, user: @current_user, reserved_at: params[:reserved_at])
          present api_success
        rescue ActiveRecord::RecordNotFound
          api_error_or_exception(10001)
        rescue AlreadyReserved
          api_error_or_exception(20006)
        end
      end
    end
  end
end