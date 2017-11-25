class ApiBooking < ApiClient

  def create_booking(start_at, end_at, client_email, price, rental_id)
    attributes = { start_at: start_at, end_at: end_at, client_email: client_email, price: price }
    post('/bookings', create_jsonapi_booking_hash(rental_id , attributes).to_json)
  end

  def index_booking
    JSON(get('/bookings')).fetch('data').map do |resource_hash|
      Booking.new(format_booking_attributes(resource_hash))
    end
  end

  def show_booking(id)
    booking_data = JSON(get"/bookings/#{id}").fetch('data')
    Booking.new(format_booking_attributes(booking_data))
  end

  def update_booking(attributes, booking_id, rental_id)
    patch("/bookings/#{booking_id}", update_jsonapi_booking_hash(booking_id, rental_id, attributes).to_json)
  end

  def destroy_booking(id)
    delete "/bookings/#{id}"
  end

  private

    def get_rental_id(resource_hash)
      resource_hash.fetch('relationships').fetch('rental').fetch('data').fetch('id')
    end

    def format_booking_attributes(resource_hash)
      attributes = resource_hash.fetch('attributes').transform_keys { |key| key.underscore }
      attributes[:id] = resource_hash['id']
      attributes[:rental_id] = get_rental_id(resource_hash)
      attributes
    end

    def create_jsonapi_booking_hash(rental_id, attributes)
      { data:
        { type: "bookings",
          relationships:
            { rental:
              { data:
                { type: "rentals", id: rental_id} } },
          attributes: attributes.transform_keys { |key| key.to_s.dasherize }
        }
      }
    end

    def update_jsonapi_booking_hash(booking_id,rental_id, attributes)
      h1 = { data: { id: booking_id } }
      create_jsonapi_booking_hash(rental_id, attributes).deep_merge(h1)
    end
end
