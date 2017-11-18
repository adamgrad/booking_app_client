class ApiBooking < ApiClient

  def create_booking(start_at, end_at, client_email, price, rental_id)
    post('/bookings', create_jsonapi_booking_hash(
        { start_at: start_at, end_at: end_at, client_email: client_email, price: price }, rental_id ))
  end

  def index_booking
    JSON(get('/bookings')).fetch('data').map do |resource_hash|
      rental_link = resource_hash.fetch('relationships').fetch('rental').fetch('links').fetch('related')
      rental_id = JSON(get"#{rental_link.gsub(host, '')}").fetch('data').fetch('id')
      Booking.new({ id: resource_hash["id"] }.merge!(resource_hash["attributes"].transform_keys { |key| key.underscore }.merge!({rental_id: rental_id}) ))
    end
  end

  def show_booking(id)
    attributes = JSON(get"/bookings/#{id}").fetch("data").fetch("attributes").transform_keys { |key| key.underscore }
    attributes[:id] = id
    Booking.new(attributes)
  end

  def destroy_booking(id)
    delete "/bookings/#{id}"
  end

  private

    def create_jsonapi_booking_hash(attributes, rental_id)
      { data:
            { type: "bookings",
              relationships:
                  { rental:
                        { data:
                              { type: "rentals", id: rental_id} } },
              attributes: attributes.transform_keys { |key| key.to_s.dasherize }
            }
      }.to_json
    end
end