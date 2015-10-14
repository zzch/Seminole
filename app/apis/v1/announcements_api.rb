# -*- encoding : utf-8 -*-
module V1
  module Announcements
    module Entities
      class List < Grape::Entity
        expose :uuid
        expose :title
        expose :summary do |m, o|
          sanitize(m.content)
        end
        with_options(format_with: :timestamp){expose :published_at}
      end

      class Detail < Grape::Entity
        expose :title
        expose :content
        with_options(format_with: :timestamp){expose :published_at}
      end
    end
  end

  class AnnouncementsAPI < Grape::API
    before do
      find_current_club
    end

    resource :announcements do
      desc '公告列表'
      params do
        optional :page, type: Integer, desc: '页码'
      end
      get do
        announcements = @current_club.announcements.published.order(published_at: :desc).page(params[:page])
        present announcements, with: Announcements::Entities::List
      end

      desc '公告详情'
      params do
        requires :uuid, type: String, desc: '公告UUID'
      end
      get :detail do
        begin
          announcement = @current_club.announcements.find_uuid(params[:uuid])
          present announcement, with: Announcements::Entities::Detail
        rescue ActiveRecord::RecordNotFound
          api_error_or_exception(10001)
        end
      end
    end
  end
end
