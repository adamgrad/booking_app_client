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
    Booking.access_api.show_booking(id)
  end

  def self.all
    Booking.access_api.index_booking
  end

  def save
    Booking.access_api.create_booking(start_at, end_at, client_email, price, rental_id)
  end

  def update_attributes(attributes)
    attributes[:price] = booking_duration(attributes) * rental_daily_rate(rental_id)
    Booking.access_api.update_booking(attributes, id, rental_id)
  end

  def destroy
    Booking.access_api.destroy_booking(id)
  end

  def rental
    Rental.access_api.show_rental(rental_id)
  end

  private

    def booking_duration(attributes)
      (attributes[:end_at].to_date - attributes[:start_at].to_date).to_i
    end

    def rental_daily_rate(rental_id)
      Rental.access_api.show_rental(rental_id).daily_rate
    end

    def self.access_api
      ApiBooking.new(ENV['HOST'], ENV['API_TOKEN'])
    end
end
