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
      end

      class Home < Grape::Entity
        present_collection true, :members
        expose :club do |m, o|
          { name: o[:club].name }
        end
        expose :members do |m, o|
          m[:members].map do |member|
            { uuid: member.uuid, number: member.number, balance: 'N/A', card: { name: member.card.name, background_color: member.card.background_color } }
          end
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
      get :home do
        find_current_club
        announcements = @current_club.announcements.published.order(published_at: :desc).limit(3)
        present @current_user.members.by_club(@current_club), with: Clubs::Entities::Home, club: @current_club, announcements: announcements
      end

      desc '会籍球场列表'
      get :membership do
        present @current_user.membership_clubs, with: Clubs::Entities::Membership
      end
    end
  end
end