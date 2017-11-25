class BookingsController < ApplicationController

  def create
    @booking = Booking.new(booking_params)
    rental_rate = Rental.find(@booking.rental_id).daily_rate
    @booking.price = (@booking.end_at - @booking.start_at).to_i / 1.day * rental_rate
    @booking.save
    respond_to do |format|
      format.html do
        redirect_to root_path
      end
      format.js { }
    end
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    @booking.update_attributes(booking_params)
    redirect_to bookings_path
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def index
    @bookings = Booking.all
  end

  def new
    @booking = Booking.new
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to bookings_path
  end

  private

    def booking_params
      params.require(:booking).permit(:start_at, :end_at, :client_email, :rental_id)
    end
end
