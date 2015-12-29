# -*- encoding : utf-8 -*-
class Op::PreferencesController < Op::BaseController
  before_action :find_preference, only: %w(show edit update)
  
  def index
    @preferences = @current_club.preferences
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @preference.update(preference_params)
      redirect_to @preference, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  protected
    def preference_params
      params.require(:preference).permit!
    end

    def find_preference
      @preference = @current_club.preferences.find(params[:id])
    end
end