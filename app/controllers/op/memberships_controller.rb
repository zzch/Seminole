# -*- encoding : utf-8 -*-
class Op::MembershipsController < Op::BaseController
  before_action :find_member, only: %w(new create)

  def new
    @nar_form = Op::CreateMembership.new
  end

  def create
    @nar_form = Op::CreateMembership.new(params[:op_create_membership])
    if @nar_form.valid?
      @nar_form.phone.gsub!(/[ -]/, '')
      begin
        @membership = Membership.create_with_user(@member, @nar_form)
        redirect_to @member, notice: '操作成功！'
      rescue DuplicatedMembership
        redirect_to @member, alert: '操作失败！该用户已加入！'
      end
    else
      render action: 'new'
    end
  end

  protected
    def find_member
      @member = @current_club.members.find(params[:member_id])
    end
end
