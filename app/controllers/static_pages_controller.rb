class StaticPagesController < ApplicationController

  def home
    @rentals = Kaminari.paginate_array(Rental.all).page(params[:page]).per(6)
  end

  def help
  end

  def about
  end

  def contact
  end

end
