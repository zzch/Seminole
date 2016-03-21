# -*- encoding : utf-8 -*-
module V1
  module Members
    module Entities
      class Tab < Grape::Entity
        expose :uuid
        expose :sequence do |m, o|
          "No. #{m.sequence.to_s.rjust(6, '0')}"
        end
      end

      class ItemList < Grape::Entity
        expose :type
      end

      class TransactionRecordList < Grape::Entity
        expose :uuid
        expose :type
        expose :action
        expose :tab, using: Tab
        expose :amount
        expose :items, using: ItemList
      end
    end
  end

  class MembersAPI < Grape::API
    resource :members do
      desc '会员卡交易记录列表'
      params do
        requires :token, type: String, desc: 'Token'
        requires :member_uuid, type: String, desc: '会员UUID'
        optional :page, type: Integer, desc: '页码'
      end
      get :transaction_records do
        transaction_records = @current_user.members.find_uuid(params[:member_uuid]).transaction_records.order(created_at: :desc).page(params[:page])
        present transaction_records, with: Members::Entities::TransactionRecordList
      end
    end
  end
end