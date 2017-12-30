class BookingsController < ApplicationController

  def create
    @booking = Booking.new(booking_params)
    @rental = Rental.find(@booking.rental_id)
    @booking.price = calculate_booking_price
    if @booking.save
      respond_to do |format|
        format.html do
          redirect_to root_path
        end
        format.js { }
      end
    else
      create_form_params
      render action: "new"
    end
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    if @booking.update_attributes(booking_params)
      redirect_to bookings_path
    else
      render action: "edit"
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
      params.require(:booking).permit(:start_at, :end_at, :client_email, :rental_id)
    end

    def create_form_params
      p = params
      p[:rental_name] = @rental.name
      p[:daily_rate] = @rental.daily_rate
      p[:rental_id] = @booking.rental_id
    end

    def calculate_booking_price
      (@booking.end_at - @booking.start_at + 1.day).to_i / 1.day * @rental.daily_rate
    end
end
