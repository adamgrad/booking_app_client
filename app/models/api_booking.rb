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
    booking_data = JSON(get"/bookings/#{id}").fetch("data")
    attributes = booking_data.fetch("attributes").transform_keys { |key| key.underscore }
    rental_link = booking_data.fetch('relationships').fetch('rental').fetch('links').fetch('related')
    rental_id = JSON(get"#{rental_link.gsub(host, '')}").fetch('data').fetch('id')
    attributes[:id] = id
    attributes[:rental_id] = rental_id.to_i
    Booking.new(attributes)
  end

  def update_booking(attributes, id, rental_id)
    patch("/bookings/#{id}", update_jsonapi_booking_hash(attributes, rental_id, id))
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

    def update_jsonapi_booking_hash(attributes, rental_id, id)
      { data:
            { type: "bookings",
              id: id,
              relationships:
                  { rental:
                        { data:
                              { type: "rentals", id: rental_id} } },
              attributes: attributes.transform_keys { |key| key.to_s.dasherize }
            }
      }.to_json
    end
end