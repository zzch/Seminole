# -*- encoding : utf-8 -*-
module V1
  class ReservationsAPI < Grape::API
    before do
      find_current_club
    end

    resource :reservations do
      desc '预订打位'
      params do
        requires :token, type: TokenParam, desc: 'Token'
        requires :club_uuid, type: UUIDParam, desc: '球场UUID'
        requires :reserve_at, type: Integer, desc: '预订时间'
      end
      post do
        @current_club.reservations.create!(user: @current_user, will_playing_at: Time.at(params[:reserve_at]))
        present api_success
      end
    end
  end
end