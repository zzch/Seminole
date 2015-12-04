# -*- encoding : utf-8 -*-
class Op::DashboardController < Op::BaseController
  
  def index
    weekly_tabs = @current_club.tabs.where('entrance_time >= ?', Time.now.beginning_of_week).where('entrance_time <= ?', Time.now)
    today_tabs = @current_club.tabs.where('entrance_time >= ?', Time.now.beginning_of_day).where('entrance_time <= ?', Time.now)
    yesterday_tabs = @current_club.tabs.where('entrance_time >= ?', (Time.now - 1.day).beginning_of_day).where('entrance_time <= ?', (Time.now - 1.day).end_of_day)
    today_members = @current_club.members.where('created_at >= ?', Time.now.beginning_of_day).where('created_at <= ?', Time.now)
    yesterday_members = @current_club.members.where('created_at >= ?', (Time.now - 1.day).beginning_of_day).where('created_at <= ?', (Time.now - 1.day).end_of_day)
    
    @member_users_count = @current_club.memberships.map(&:user_id).uniq.count
    @weekly_member_users_count = weekly_tabs.select{|tab| tab.user.activated?}.map(&:user_id).uniq.count
    @weekly_visitor_users_count = weekly_tabs.select{|tab| !tab.user.activated?}.map(&:user_id).uniq.count
    @today_users_count = today_tabs.map(&:user_id).uniq.count
    @today_vacancies_usage = ((today_tabs.includes(:playing_items).map{|tab| tab.playing_items.map{|playing_item| (playing_item.finished_at || Time.now) - playing_item.started_at}.reduce(:+)}.reduce(:+) || 0) / ((Time.now - Time.local(Time.now.year, Time.now.month, Time.now.day, 9, 30)) * @current_club.vacancies.count)).round(2)
    @yesterday_users_count = yesterday_tabs.map(&:user_id).uniq.count
    @today_item_revenue = (today_tabs.map(&:price).reduce(:+) || 0)
    @today_member_revenue = (today_members.map{|member| member.card.price}.reduce(:+) || 0)
    @today_total_revenue = @today_item_revenue + @today_member_revenue
    @yesterday_item_revenue = (yesterday_tabs.map(&:price).reduce(:+) || 0)
    @yesterday_member_revenue = (yesterday_members.map{|member| member.card.price}.reduce(:+) || 0)
    @yesterday_total_revenue = @yesterday_item_revenue + @yesterday_member_revenue
  end
end