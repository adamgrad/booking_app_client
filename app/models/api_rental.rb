class ApiRental < ApiClient

  def create_rental(name, daily_rate)
    response_body = post('/rentals', create_jsonapi_rental_hash({ name: name, daily_rate: daily_rate } ))
    JSON(response_body).fetch('data').fetch('id')
  end

  def index_rental
    JSON(get('/rentals')).fetch("data").map do |resource_hash|
      Rental.new({ id: resource_hash["id"]}.merge!(resource_hash["attributes"].transform_keys { |key| key.underscore }))
    end
  end

  def show_rental(id)
    attributes = JSON(get"/rentals/#{id}").fetch("data").fetch("attributes").transform_keys { |key| key.underscore }
    attributes[:id] = id
    Rental.new(attributes)
  end

  def update_rental(attributes, id)
    patch("/rentals/#{id}", update_jsonapi_rental_hash(attributes, id))
  end

  def destroy_rental(id)
    delete "/rentals/#{id}"
  end

  def get_rental_bookings(rental_id)
    bookings_link = JSON(get("/rentals/#{rental_id}")).fetch('data').fetch('relationships').fetch('bookings')
                                                           .fetch('links').fetch('related')
    JSON(get(bookings_link)).fetch('data').map do |resource_hash|
      Booking.new({ id: resource_hash["id"] }.merge!(resource_hash["attributes"]
                                                         .transform_keys { |key| key.underscore }.merge!({rental_id: rental_id}) ))
    end
  end

  private

    def create_jsonapi_rental_hash(attributes)
        {
            data: {
                type: 'rentals',
                attributes: attributes.transform_keys { |key| key.to_s.dasherize }
            }
        }.to_json
    end

    def update_jsonapi_rental_hash(attributes, id)
      {
          data: {
              type: 'rentals',
              id: id,
              attributes: attributes.transform_keys { |key| key.to_s.dasherize }
          }
      }.to_json
    end
end