# -*- encoding : utf-8 -*-
class Op::TabsController < Op::BaseController
  before_action :find_tab, only: %w(show cancel checkout print checking)
  
  def index
    @tabs = Tab.page(params[:page])
  end
  
  def show
    if @tab.progressing?
      render 'progressing_show'
    else
      @playing_items = @tab.playing_items.includes(:balls).includes(:vacancy)
      @provision_items = @tab.provision_items
      @extra_items = @tab.extra_items
      @members = @tab.user.members.by_club(@current_club).includes(:card)
      @stored_card_members = @members.select{|member| member.card.type_stored?}
      render 'finished_show'
    end
  end
  
  def new
    @tab = Tab.new
    @vacancy = @current_club.vacancies.find(params[:vacancy_id]) if params[:vacancy_id]
    @nar_form = Op::VisitorSetUpTab.new
  end
  
  def member_set_up
    begin
      @tab = Tab.set_up(tab_params.merge({ club_id: @current_club.id, operator_id: session['operator']['id'] }), params[:vacancy_ids])
      redirect_to @tab, notice: '操作成功！'
    rescue AlreadyInUse
      render action: 'new'
    end
  end

  def visitor_set_up
    begin
      @nar_form = Op::VisitorSetUpTab.new(params[:op_visitor_set_up_tab])
      @nar_form.phone.gsub!(/[ -]/, '')
      user = User.find_or_create_visitor(@nar_form)
      @tab = Tab.set_up({ club_id: @current_club.id, user_id: user.id, operator_id: session['operator']['id'] }, params[:vacancy_ids])
      redirect_to @tab, notice: '操作成功！'
    rescue AlreadyInUse
      render action: 'new'
    end
  end

  def checkout
    @playing_items = @tab.playing_items.includes(:balls).includes(:vacancy)
    @provision_items = @tab.provision_items
    @extra_items = @tab.extra_items
    @members = @tab.user.members.by_club(@current_club).includes(:card)
    @stored_card_members = @members.select{|member| member.card.type_stored?}
  end

  def print
    render layout: false
  end

  def checking
    begin
      @tab.checking(params[:method])
      redirect_to @tab, notice: '操作成功！'
    rescue UndeterminedItem
      redirect_to checkout_tab_path(@tab), alert: '操作失败！存在未确定的消费条目！'
    rescue InvalidState
      redirect_to checkout_tab_path(@tab), alert: '操作失败！消费单状态不正确！'
    rescue InvalidConfirmMethod
      redirect_to checkout_tab_path(@tab), alert: '操作失败！无效的确认方式！'
    rescue InvalidCardType
      redirect_to checkout_tab_path(@tab), alert: '操作失败！卡类型不正确！'
    rescue InvalidCharingType
      redirect_to checkout_tab_path(@tab), alert: '操作失败！付款类型无效！'
    rescue InsufficientBall
      redirect_to checkout_tab_path(@tab), alert: '操作失败！计球卡余额不足！'
    rescue InsufficientMinute
      redirect_to checkout_tab_path(@tab), alert: '操作失败！计时卡余额不足！'
    rescue InsufficientDeposit
      redirect_to checkout_tab_path(@tab), alert: '操作失败！储值卡余额不足！'
    end
  end
  
  def cancel
    begin
      @tab.cancel!
      redirect_to @tab, notice: '取消成功！'
    rescue AlreadyInUse
      render action: 'new'
    end
  end

  def progressing
    @tabs = @current_club.tabs.progressing.page(params[:page])
  end

  def finished
    @tabs = @current_club.tabs.finished.page(params[:page])
  end

  def cancelled
    @tabs = @current_club.tabs.cancelled.page(params[:page])
  end

  protected
    def tab_params
      params.require(:tab).permit!
    end

    def find_tab
      @tab = @current_club.tabs.find(params[:id])
    end
end