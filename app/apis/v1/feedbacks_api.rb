# -*- encoding : utf-8 -*-
module V1
  class FeedbacksAPI < Grape::API
    before do
      find_current_club
    end

    resource :feedbacks do
      desc '提交意见反馈'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        requires :content, type: String, desc: '内容'
      end
      post do
        @current_club.feedbacks.create!(user: @current_user, content: params[:content])
        present api_success
      end
    end
  end
end