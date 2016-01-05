# -*- encoding : utf-8 -*-
module V1
  module Sessions
    module Entities
      class Welcome < Grape::Entity
        expose :sentences do |m, o|
          hello = case Time.now.hour
          when (0..11) then '上午好'
          when (12..13) then '中午好'
          when (14..17) then '下午好'
          when (18..23) then '晚上好'
          end
          [
            "#{hello}，#{m.last_name}#{m.human_gender}",
            "欢迎光临#{o[:club].short_name || o[:club].name}"
          ]
        end
      end

      class SignIn < Grape::Entity
        expose :user do |m, o|
          { name: m.name, gender: m.gender, portrait: m.portrait.w150_h150_fl_q50.url, birthday: m.birthday.try(:to_i), token: m.token }
        end
        expose :club do |m, o|
          { uuid: o[:club].uuid }
        end
      end
    end
  end

  class SessionsAPI < Grape::API
    resource :welcome do
      desc '用户欢迎信息'
      params do
        requires :phone, type: Integer, regexp: /\A1[0-9]{10}\z/, desc: '手机号'
        optional :latitude, type: String, desc: '纬度'
        optional :longitude, type: String, desc: '经度'
      end
      get do
        begin
          user = User.where(phone: params[:phone]).first
          raise UserNotFound.new if user.nil?
          raise UnactivatedUser.new unless user.activated?
          present user, with: Sessions::Entities::Welcome, club: user.nearest_club(params[:latitude], params[:longitude])
        rescue UserNotFound
          api_error_or_exception(20001)
        rescue UnactivatedUser
          api_error_or_exception(20002)
        end
      end
    end

    resource :sign_in do
      desc '用户登入'
      params do
        requires :phone, type: Integer, regexp: /\A1[0-9]{10}\z/, desc: '手机号'
        requires :verification_code, type: Integer, regexp: /\A[0-9]{4}\z/, desc: '验证码'
        optional :latitude, type: String, desc: '纬度'
        optional :longitude, type: String, desc: '经度'
      end
      post do
        begin
          user = User.sign_in(params[:phone], params[:verification_code])
          present user, with: Sessions::Entities::SignIn, club: user.nearest_club(params[:latitude], params[:longitude])
        rescue UserNotFound
          api_error_or_exception(20001)
        rescue UnactivatedUser
          api_error_or_exception(20002)
        rescue IncorrectVerificationCode
          api_error_or_exception(20003)
        end
      end
    end

    resource :sign_out do
      desc '用户登出'
      params do
        requires :token, type: String, desc: 'Token'
      end
      delete do
        authenticate!
        @current_user.sign_out
        present api_success
      end
    end
  end
end