# -*- encoding : utf-8 -*-
class Op::DashboardController < Op::BaseController
  
  def index
    weekly_tabs = @current_club.tabs.finished.where('departure_time >= ?', Time.now.beginning_of_week).where('departure_time <= ?', Time.now)
    today_tabs = @current_club.tabs.finished.where('departure_time >= ?', Time.now.beginning_of_day).where('departure_time <= ?', Time.now)
    yesterday_tabs = @current_club.tabs.finished.where('departure_time >= ?', (Time.now - 1.day).beginning_of_day).where('departure_time <= ?', (Time.now - 1.day).end_of_day)
    recently_tabs = @current_club.tabs.finished.where('entrance_time >= ?', (Time.now - 8.days).beginning_of_day).where('entrance_time <= ?', Time.now.yesterday.end_of_day)
    today_members = @current_club.members.where('created_at >= ?', Time.now.beginning_of_day).where('created_at <= ?', Time.now)
    yesterday_members = @current_club.members.where('created_at >= ?', (Time.now - 1.day).beginning_of_day).where('created_at <= ?', (Time.now - 1.day).end_of_day)
    
    @recently_reservations = @current_club.reservations.where('will_playing_at >= ?', Time.now.beginning_of_day).where('will_playing_at <= ?', Time.now.end_of_day + 2.days).order(will_playing_at: :desc)
    @member_users_count = @current_club.memberships.map(&:user_id).uniq.count
    @weekly_member_users_count = weekly_tabs.select{|tab| tab.user.activated?}.map(&:user_id).uniq.count
    @weekly_visitor_users_count = weekly_tabs.select{|tab| !tab.user.activated?}.map(&:user_id).uniq.count
    @today_users_count = today_tabs.map(&:user_id).uniq.count
    @today_vacancies_usage = ((today_tabs.includes(:playing_items).select{|tab| !tab.playing_items.count.zero?}.map{|tab| tab.playing_items.map{|playing_item| (playing_item.finished_at || Time.now) - playing_item.started_at}.reduce(:+)}.reduce(:+) || 0) / ((Time.now - Time.local(Time.now.year, Time.now.month, Time.now.day, 9, 30)) * @current_club.vacancies.count)).round(2)
    @yesterday_users_count = yesterday_tabs.map(&:user_id).uniq.count
    @today_item_revenue = (today_tabs.map(&:price).compact.reduce(:+) || 0)
    @today_member_revenue = (today_members.map{|member| member.card.price}.reduce(:+) || 0)
    @today_total_revenue = @today_item_revenue + @today_member_revenue
    @yesterday_item_revenue = (yesterday_tabs.map(&:price).compact.reduce(:+) || 0)
    @yesterday_member_revenue = (yesterday_members.map{|member| member.card.price}.reduce(:+) || 0)
    @yesterday_total_revenue = @yesterday_item_revenue + @yesterday_member_revenue
    recently_member_chart = Hash[8.downto(1).map{|i| [(Time.now - i.day).strftime("%m/%d"), 0]}]
    recently_tabs.includes(:user).where(users: { activated: true }).each{|tab| recently_member_chart[tab.created_at.strftime('%m/%d')] += 1}
    recently_visitor_chart = Hash[8.downto(1).map{|i| [(Time.now - i.day).strftime("%m/%d"), 0]}]
    recently_tabs.includes(:user).where(users: { activated: false }).each{|tab| recently_visitor_chart[tab.created_at.strftime('%m/%d')] += 1}
    @recently_users_chart = { member: recently_member_chart, visitor: recently_visitor_chart }
    @card_types_chart = @current_club.members.includes(:card).select{|member| member.available?}.map{|member| member.card.type}.inject(Hash.new(0)){|r, e| r[e] += 1; r}
  end
end