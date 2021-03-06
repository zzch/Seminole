# -*- encoding : utf-8 -*-
module V1
  module Clubs
    module Entities
      class Membership < Grape::Entity
        expose :uuid
        expose :name
        expose :logo do |m, o|
          m.logo.w150_h150_fl_q50.url
        end
        expose :phone_number
        expose :address
      end

      class Home < Grape::Entity
        present_collection true, :members
        expose :club do |m, o|
          { name: o[:club].name, logo: o[:club].logo.w150_h150_fl_q50.url }
        end
        expose :members do |m, o|
          m[:members].map do |member|
            { uuid: member.uuid, number: member.number, balance: member.balance, expired_at: member.expired_at.to_i, card: { name: member.card.name, background_color: member.card.background_color, font_color: member.card.font_color } }
          end
        end
        expose :weather do |m, o|
          { date: o[:weather].date.to_datetime.to_i, maximum_temperature: o[:weather].maximum_temperature }
        end
        expose :announcements do |m, o|
          o[:announcements].map do |announcement|
            { uuid: announcement.uuid, title: announcement.title, published_at: announcement.published_at.to_i }
          end
        end
      end
    end
  end

  class ClubsAPI < Grape::API
    resource :clubs do
      desc '球场首页'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
      end
      get :home do
        find_current_club
        announcements = @current_club.announcements.published.order(published_at: :desc).limit(3)
        weather = @current_club.weathers.recently(Time.now, 1).first
        present @current_user.members.by_club(@current_club), with: Clubs::Entities::Home, club: @current_club, announcements: announcements, weather: weather
      end

      desc '会籍球场列表'
      params do
        requires :token, type: String, desc: 'Token'
      end
      get :membership do
        present @current_user.membership_clubs, with: Clubs::Entities::Membership
      end
    end
  end
end