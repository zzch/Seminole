# -*- encoding : utf-8 -*-
module V1
  module Provisions
    module Entities
      class Detail < Grape::Entity
        expose :name
        expose :image do |m, o|
          m.image.w150_h150_fl_q50.url
        end
        expose :price
      end

      class List < Grape::Entity
        expose :name
        expose :provisions, using: Detail
      end
    end
  end

  class ProvisionsAPI < Grape::API
    before do
      find_current_club
    end

    resource :provisions do
      desc '餐饮列表'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
      end
      get do
        provision_categories = @current_club.provision_categories
        present provision_categories, with: Provisions::Entities::List
      end
    end
  end
end