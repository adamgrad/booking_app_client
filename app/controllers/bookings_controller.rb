class BookingsController < ApplicationController

  def create
    @booking = Booking.new(booking_params)
    @booking.price *= (@booking.end_at.to_date.day - @booking.start_at.to_date.day)
    @booking.save
    respond_to do |format|
      format.html do
        redirect_to root_path
      end
      format.js { }
    end
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
      params.require(:booking).permit(:start_at, :end_at, :client_email, :price, :rental_id)
    end
end