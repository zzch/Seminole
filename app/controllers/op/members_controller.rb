# -*- encoding : utf-8 -*-
class Op::MembersController < Op::BaseController
  before_action :find_member, only: %w( show edit update )
  
  def index
    @members = Member.page(params[:page])
  end
  
  def show
    @member = Member.find(params[:id])
  end
  
  def new
    @member = Member.new
  end
  
  def edit
    @member = Member.find(params[:id])
  end
  
  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to [:cms, @member], notice: '创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to [:cms, @member], notice: '更新成功！'
    else
      render action: 'edit'
    end
  end

  def new_visitor
    @nar_form = Op::CreateVisitorMember.new
  end

  def create_visitor
    @nar_form = Op::CreateVisitorMember.new(params[:op_create_visitor_member])
    if @nar_form.valid?
      @member = @current_club.members.create_visitor(@nar_form)
      redirect_to @member, notice: '创建成功！'
    else
      render action: 'new_visitor'
    end
  end

  def new_regular
    @nar_form = Op::CreateRegularMember.new
  end

  def create_regular
    @nar_form = Op::CreateRegularMember.new(params[:op_create_regular_member])
    if @nar_form.valid?
      @member = @current_club.members.create_regular(@nar_form)
      redirect_to @member, notice: '创建成功！'
    else
      render action: 'new_regular'
    end
  end

  protected
    def member_params
      params.require(:member).permit(:account, :password, :password_confirmation, :name, :available)
    end

    def find_member
      @member = Member.find(params[:id])
    end
end
