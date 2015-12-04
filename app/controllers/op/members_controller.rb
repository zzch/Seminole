# -*- encoding : utf-8 -*-
class Op::MembersController < Op::BaseController
  before_action :find_member, only: %w(show edit update)
  
  def index
    @members = @current_club.members.order(created_at: :desc, id: :asc).page(params[:page])
  end
  
  def show
  end

  def new
    @nar_form = Op::CreateMember.new
  end
  
  def edit
  end

  def create
    @nar_form = Op::CreateMember.new(params[:op_create_member])
    if @nar_form.valid?
      @nar_form.phone.gsub!(/[ -]/, '')
      @member = Member.create_with_user(@current_club, @nar_form)
      redirect_to @member, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @member.update(member_params)
      redirect_to @member, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  def async_search
    begin
      raise CannotBeBlank.new if params[:keyword].strip.blank?
      user = Member.search(@current_club, params[:keyword])
      render json: AjaxMessenger.new(user)
    rescue CannotBeBlank
      render json: AjaxMessenger.new('关键字不能为空', false)
    rescue DoesNotExist
      render json: AjaxMessenger.new('找不到任何用户', false)
    end
  end

  protected
    def member_params
      params.require(:member).permit!
    end

    def find_member
      @member = @current_club.members.find(params[:id])
    end
end
