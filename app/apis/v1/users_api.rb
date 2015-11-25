# -*- encoding : utf-8 -*-
module V1
  module Users
    module Entities
      class Detail < Grape::Entity
        expose :name
        expose :gender
        expose :portrait do |m, o|
          m.portrait.w150_h150_fl_q50.url
        end
        expose :birthday do |m, o|
          m.birthday.try(:to_time).try(:to_i)
        end
      end
    end
  end

  class UsersAPI < Grape::API
    resource :users do
      desc '用户详情'
      params do
        requires :token, type: String, desc: 'Token'
      end
      get :detail do
        present @current_user, with: Users::Entities::Detail
      end

      desc '更新头像'
      params do
        requires :token, type: String, desc: 'Token'
        requires :portrait, desc: '头像'
      end
      put :portrait do
        @current_user.update!(portrait: params[:portrait])
        present api_success
      end

      desc '更新生日'
      params do
        requires :token, type: String, desc: 'Token'
        requires :birthday, type: Integer, desc: '生日'
      end
      put :birthday do
        @current_user.update!(birthday: Time.at(params[:birthday]))
        present api_success
      end

      desc '更新推送ID'
      params do
        requires :token, type: String, desc: 'Token'
        requires :registration_id, type: String, desc: '推送ID'
      end
      put :registration_id do
        @current_user.update!(registration_id: params[:registration_id])
        present api_success
      end
    end
  end
end