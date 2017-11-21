class Booking
  include ActiveModel::Model
  include ActiveModelAttributes

  attribute :id, :integer
  attribute :start_at, :datetime
  attribute :end_at, :datetime
  attribute :client_email, :string
  attribute :price, :decimal
  attribute :rental_id, :integer

  def to_param
    id.to_s
  end

  def self.find(id)
    api_booking = ApiBooking.new(ENV["HOST"], ENV["API_TOKEN"])
    api_booking.show_booking(id)
  end

  def self.all
    api_booking = ApiBooking.new(ENV["HOST"], ENV["API_TOKEN"])
    api_booking.index_booking
  end

  def save
    api_booking = ApiBooking.new(ENV["HOST"], ENV["API_TOKEN"])
    api_booking.create_booking(start_at, end_at, client_email, price, rental_id)
  end

  def update_attributes(attributes)
    api_booking = ApiBooking.new(ENV["HOST"], ENV["API_TOKEN"])
    api_booking.update_booking(attributes, id, rental_id)
  end

  def destroy
    api_booking = ApiBooking.new(ENV["HOST"], ENV["API_TOKEN"])
    api_booking.destroy_booking(id)
  end

  def rental
    api_rental = ApiRental.new(ENV["HOST"], ENV["API_TOKEN"])
    api_rental.show_rental(rental_id)
  end
end