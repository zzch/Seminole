# -*- encoding : utf-8 -*-
module V1
  module Reservations
    module Entities
      class Club < Grape::Entity
        expose :name
      end

      class List < Grape::Entity
        expose :club, using: Club
        with_options(format_with: :timestamp){expose :will_playing_at}
        expose :state
      end
    end
  end

  class ReservationsAPI < Grape::API
    resource :reservations do
      desc '预约打位'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        requires :reserve_at, type: Integer, desc: '预订时间'
      end
      post do
        find_current_club
        begin
          @current_club.reservations.create!(user: @current_user, will_playing_at: Time.at(params[:reserve_at]))
          present api_success
        rescue DuplicatedReservation
          api_error_or_exception(20004)
        end
      end

      desc '预约列表'
      params do
        requires :token, type: String, desc: 'Token'
        optional :page, type: Integer, desc: '页数'
      end
      get do
        reservations = @current_user.reservations.order(will_playing_at: :desc).page(params[:page])
        present reservations, with: Reservations::Entities::List
      end
    end
  end
end