# -*- encoding : utf-8 -*-
class Op::TabsController < Op::BaseController
  before_action :find_tab, only: %w(show cancel checkout)
  
  def index
    @tabs = Tab.page(params[:page])
  end
  
  def show
  end
  
  def new
    @tab = Tab.new
    @vacancy = @current_club.vacancies.find(params[:vacancy_id]) if params[:vacancy_id]
    @nar_form = Op::VisitorSetUpTab.new
  end
  
  def member_set_up
    begin
      @tab = Tab.set_up(tab_params.merge({ club_id: @current_club.id, operator_id: session['operator']['id'] }), params[:vacancy_id])
      redirect_to @tab, notice: '操作成功！'
    rescue AlreadyInUse
      render action: 'new'
    end
  end

  def visitor_set_up
    begin
      user = User.find_or_create_visitor(Op::VisitorSetUpTab.new(params[:op_visitor_set_up_tab]))
      @tab = Tab.set_up({ club_id: @current_club.id, user_id: user.id, operator_id: session['operator']['id'] }, params[:vacancy_id])
      redirect_to @tab, notice: '操作成功！'
    rescue AlreadyInUse
      render action: 'new'
    end
  end

  def checkout
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
      @tab = Tab.find(params[:id])
    end
end