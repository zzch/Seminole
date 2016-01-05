# -*- encoding : utf-8 -*-
class Op::SearchController < Op::BaseController

  def create
    keyword = params[:keyword].strip
    member_ids = @current_club.members.where("number LIKE '%#{keyword}%'").map(&:id)
    member_ids = [0] if member_ids.blank?
    user_ids = User.where(id: @current_club.memberships.map(&:user_id).uniq).where("CONCAT(last_name, first_name) LIKE '%#{keyword}%' OR phone LIKE '%#{keyword}%'").map(&:id)
    user_ids = [0] if user_ids.blank?
    @memberships = Membership.joins(:member).where(members: { club_id: @current_club.id }).where("member_id IN (#{member_ids.join(', ')}) OR user_id IN (#{user_ids.join(', ')})")
    render 'result'
  end
end