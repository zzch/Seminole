# -*- encoding : utf-8 -*-
class Op::ReservationsController < Op::BaseController
  before_action :find_reservation, only: %w(show edit update destroy)
  
  def index
    @reservations = @current_club.reservations.order(will_playing_at: :desc).page(params[:page])
  end
  
  def show
  end
  
  def new
    @reservation = Reservation.new
  end
  
  def edit
  end
  
  def create
    begin
      @reservation = @current_club.reservations.new(reservation_params)
      @reservation.will_playing_at = convert_picker_to_datetime(reservation_params[:will_playing_at_date], reservation_params[:will_playing_at_time])
      if @reservation.save
        redirect_to @reservation, notice: '操作成功！'
      else
        render action: 'new'
      end
    rescue DuplicatedReservation
      redirect_to @reservation, alert: '操作失败！重复预约！'
    end
  end
  
  def update
    @reservation.will_playing_at = convert_picker_to_datetime(reservation_params[:will_playing_at_date], reservation_params[:will_playing_at_time])
    if @reservation.update(reservation_params)
      redirect_to @reservation, notice: '操作成功！'
    else
      render action: 'edit'
    end
  end

  def destroy
    @reservation.destroy
    redirect_to reservations_path, notice: '操作成功！'
  end

  protected
    def reservation_params
      params.require(:reservation).permit!
    end

    def find_reservation
      @reservation = @current_club.reservations.find(params[:id])
    end
end