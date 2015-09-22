# -*- encoding : utf-8 -*-
class Admin::ClubsController < Admin::BaseController
  
  def index
    @clubs = Club.page(params[:page])
  end
  
  def show
    @club = Club.find(params[:id])
    @operators = @club.operators
  end
  
  def new
    @club = Club.new
  end
  
  def edit
    @club = Club.find(params[:id])
  end
  
  def create
    @club = Club.new(club_params)
    if @club.save
      redirect_to [:admin, @club], notice: '创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @club = Club.find(params[:id])
    if @club.update(club_params)
      redirect_to [:admin, @club], notice: '更新成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def club_params
      params.require(:club).permit!
    end
end
