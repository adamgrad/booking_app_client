class RentalsController < ApplicationController

  def create
    @rental = Rental.new(rental_params)
    @rental.save
    redirect_to rental_url(@rental)
  end

  def index
    @rentals = Rental.all
  end

  def show
    @rental = Rental.find(params[:id])
  end

  def edit
    @rental = Rental.find(params[:id])
  end

  def update
    @rental = Rental.find(params[:id])
    @rental.update_attributes(rental_params)
    redirect_to rentals_path
  end

  def new
    @rental = Rental.new
  end

  def destroy
    @rental = Rental.find(params[:id])
    @rental.destroy
    redirect_to rentals_path
  end

  private

    def rental_params
      params.require(:rental).permit(:name, :daily_rate)
    end
end