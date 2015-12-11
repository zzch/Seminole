# -*- encoding : utf-8 -*-
class Op::AnnouncementsController < Op::BaseController
  before_action :find_announcement, only: %w(show edit update)
  
  def index
    @announcements = @current_club.announcements.page(params[:page])
  end
  
  def show
  end
  
  def new
    @announcement = Announcement.new
  end
  
  def edit
  end
  
  def create
    @announcement = @current_club.announcements.new(announcement_params)
    @announcement.published_at = Time.now
    if @announcement.save
      redirect_to @announcement, notice: '操作成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    if @announcement.update(announcement_params)
      redirect_to @announcement, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def announcement_params
      params.require(:announcement).permit!
    end

    def find_announcement
      @announcement = @current_club.announcements.find(params[:id])
    end
end