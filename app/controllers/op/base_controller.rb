# -*- encoding : utf-8 -*-
class Op::BaseController < ApplicationController
  include BracHelper
  layout 'op'
  before_action :find_club
  before_action :authenticate
  before_action :find_notifications

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  protected
    def render_error status, exception
      #Error.create(caller: "Administrator-#{session['administrator']['id']}", name: exception.class.to_s, message: exception.message, backtrace: "<p>#{exception.backtrace.try(:join, '</p><p>')}</p>")
      render template: "op/errors/error_#{status}", status: status
    end

    def find_club
      redirect_to public_welcome_path unless @current_club = Club.where(code: request.subdomain).first
    end
    
    def authenticate
      redirect_to sign_in_path if session['operator'].blank?
    end
    
    def find_notifications
      @unread_notifications_count = OperatorNotification.by_operator(session['operator']['id']).unread.count
      @unread_notifications_count = '99+' if @unread_notifications_count > 99
      @dropdown_notifications = OperatorNotification.by_operator(session['operator']['id']).unread.latest.limit(5)
    end

    def convert_picker_to_datetime date, time = nil
      "#{date} #{time || '00:00:00'}".to_datetime - 8.hours
    end
end
