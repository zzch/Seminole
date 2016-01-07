# -*- encoding : utf-8 -*-
module V1
  module Promotions
    module Entities
      class List < Grape::Entity
        expose :uuid
        expose :image do |m, o|
          m.image.w640_h350_fl_q80.url
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

  class PromotionsAPI < Grape::API
    before do
      find_current_club
    end

    resource :promotions do
      desc '商城活动列表'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        optional :page, type: Integer, desc: '页数'
      end
      get do
        promotions = @current_club.promotions.published.order(published_at: :desc).page(params[:page])
        present promotions, with: Promotions::Entities::List
      end

      desc '商城活动详情'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        requires :uuid, type: String, desc: '商城活动UUID'
      end
      get :detail do
        begin
          promotions = @current_club.promotions.published.find_uuid(params[:uuid])
          present promotions, with: Promotions::Entities::Detail
        rescue ActiveRecord::RecordNotFound
          api_error_or_exception(10001)
        end
      end
    end
  end
end