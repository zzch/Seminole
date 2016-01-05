# -*- encoding : utf-8 -*-
class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :authenticate

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  protected
    def render_error status, exception
      #Error.create(caller: "Administrator-#{session['administrator']['id']}", name: exception.class.to_s, message: exception.message, backtrace: "<p>#{exception.backtrace.try(:join, '</p><p>')}</p>")
      render template: "admin/errors/error_#{status}", status: status
    end
    
    def authenticate
      redirect_to admin_sign_in_path if session['administrator'].blank?
    end
end