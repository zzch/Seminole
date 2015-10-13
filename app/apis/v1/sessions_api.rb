# -*- encoding : utf-8 -*-
module V1
  class SessionsAPI < Grape::API
    resource :welcome do
      desc '获取用户欢迎信息'
      # params do
      #   requires :phone, type: Integer, desc: '手机号'
      # end
      get '/' do
        present successful_json
      end
    end

    resource :sign_in do
      desc '用户登录'
      params do
        requires :content, type: String, desc: '内容'
      end
      post do
        present successful_json
      end
    end

    resource :sign_out do
      desc '用户退出'
      params do
        requires :content, type: String, desc: '内容'
      end
      delete do
        present successful_json
      end
    end
  end
end
