# -*- encoding : utf-8 -*-
module V1
  module Tabs
    module Entities
      class Club < Grape::Entity
        expose :name
      end

      class List < Grape::Entity
        expose :uuid
        expose :sequence do |m, o|
          "No. #{m.sequence.to_s.rjust(6, '0')}"
        end
        expose :reception_payment do |m, o|
          "#{sprintf('%0.02f', m.cash)}元" unless m.cash.blank?
        end
        with_options(format_with: :timestamp){expose :entrance_time}
        with_options(format_with: :timestamp){expose :departure_time}
        expose :club, using: Tabs::Entities::Club, if: lambda {|m, o| o[:include_club]}
        expose :items do |m, o|
          m.playing_items.map do |playing_item|
            total_price = case playing_item.payment_method
            when :by_ball_member then "#{playing_item.total_balls / (o[:club].try(:balls_per_bucket) || playing_item.member.club.balls_per_bucket)}筐球"
            when :by_time_member then "#{(playing_item.seconds.to_f / 60).round}分钟"
            when :unlimited_member then '-'
            else "#{sprintf('%0.02f', playing_item.total_price)}元"
            end
            { name: "#{playing_item.vacancy.name}打位", total_price: total_price, payment_method: playing_item.payment_method }
          end +
          m.provision_items.map do |provision_item|
            { name: "#{provision_item.provision.name}x#{provision_item.quantity}", total_price: "#{sprintf('%0.02f', provision_item.total_price)}元", payment_method: provision_item.payment_method }
          end +
          m.extra_items.map do |extra_item|
            { name: "#{extra_item.type}", total_price: extra_item.price, payment_method: extra_item.payment_method }
          end
        end
        expose :state
      end

      class Detail < Grape::Entity
        expose :sequence do |m, o|
          "No. #{m.sequence.to_s.rjust(6, '0')}"
        end
        expose :reception_payment do |m, o|
          "#{sprintf('%0.02f', m.cash)}元" unless m.cash.blank?
        end
        with_options(format_with: :timestamp){expose :entrance_time}
        with_options(format_with: :timestamp){expose :departure_time}
        expose :items do |m, o|
          m.playing_items.map do |playing_item|
            total_price = case playing_item.payment_method
            when :by_ball_member then "#{playing_item.total_balls / playing_item.member.club.balls_per_bucket}筐球"
            when :by_time_member then "#{(playing_item.seconds.to_f / 60).round}分钟"
            when :unlimited_member then '-'
            else "#{sprintf('%0.02f', playing_item.total_price)}元"
            end
            { name: "#{playing_item.vacancy.name}打位", total_price: total_price, payment_method: playing_item.payment_method }
          end +
          m.provision_items.map do |provision_item|
            { name: "#{provision_item.provision.name}x#{provision_item.quantity}", total_price: "#{sprintf('%0.02f', provision_item.total_price)}元", payment_method: provision_item.payment_method }
          end +
          m.extra_items.map do |extra_item|
            { name: "#{extra_item.type}", total_price: extra_item.price, payment_method: extra_item.payment_method }
          end
        end
        expose :state
      end
    end
  end

  class TabsAPI < Grape::API
    resource :tabs do
      desc '球场消费单列表'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        optional :page, type: Integer, desc: '页码'
      end
      get do
        find_current_club
        tabs = @current_user.tabs.handled.by_club(@current_club).order(entrance_time: :desc).page(params[:page]).per(10)
        present tabs, with: Tabs::Entities::List, club: @current_club
      end

      desc '全部消费单列表'
      params do
        requires :token, type: String, desc: 'Token'
        optional :page, type: Integer, desc: '页码'
      end
      get :all do
        tabs = @current_user.tabs.handled.order(entrance_time: :desc).page(params[:page]).per(10)
        present tabs, with: Tabs::Entities::List, include_club: true
      end

      desc '消费单详情'
      params do
        requires :token, type: String, desc: 'Token'
        requires :uuid, type: String, desc: '消费单UUID'
      end
      get :detail do
        tab = @current_user.tabs.find_uuid(params[:uuid])
        present tab, with: Tabs::Entities::Detail
      end

      desc '确认消费单'
      params do
        requires :token, type: String, desc: 'Token'
        requires :club_uuid, type: String, desc: '球场UUID'
        optional :uuid, type: String, desc: '消费单UUID'
      end
      put :confirm do
        find_current_club
        tab = @current_user.tabs.find_uuid(params[:uuid])
        begin
          tab.confirm
          present api_success
        rescue InvalidState
          api_error_or_exception(20005)
        end
      end
    end
  end
end