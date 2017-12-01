class ApiRental < ApiClient

  def create_rental(name, daily_rate)
    response_body = post('/rentals', create_jsonapi_rental_hash({ name: name, daily_rate: daily_rate } ).to_json)
    response_hash = JSON response_body
    has_errors?(response_body) ? nil : get_rental_id(response_hash)
  end

  def index_rental
    JSON(get('/rentals')).fetch('data').map do |resource_hash|
      Rental.new(format_rental_attributes(resource_hash))
    end
  end

  def show_rental(id)
    attributes = JSON(get "/rentals/#{id}").fetch('data')
    Rental.new(format_rental_attributes(attributes))
  end

  def update_rental(id, attributes)
    patch("/rentals/#{id}", update_jsonapi_rental_hash(attributes, id))
  end

  def destroy_rental(id)
    delete "/rentals/#{id}"
  end

  def get_rental_bookings(rental_id)
    bookings_link = get_bookings_link(rental_id)
    get_booking_json_data(bookings_link).map do |resource_hash|
      Booking.new(format_booking_data(rental_id, resource_hash))
    end
  end

  private

    def get_rental_id(data_hash)
      data_hash.fetch('data').fetch('id')
    end

    def has_errors?(response_hash)
      response_hash.include?('errors') ? true : false
    end

    def get_bookings_link(rental_id)
      link = JSON(get "/rentals/#{rental_id}")
      link.fetch('data').fetch('relationships').fetch('bookings').fetch('links').fetch('related')
    end

    def get_booking_json_data(link)
      JSON(get link).fetch('data')
    end

    def format_booking_data(rental_id, resource_hash)
      attributes = resource_hash.fetch('attributes').transform_keys { |key| key.underscore }
      attributes[:id] = resource_hash['id']
      attributes[:rental_id] = rental_id
      attributes
    end

    def format_rental_attributes(resource_hash)
      attributes = resource_hash.fetch('attributes').transform_keys { |key| key.underscore }
      attributes[:id] = resource_hash.fetch('id')
      attributes
    end

    def create_jsonapi_rental_hash(attributes)
      { data:
        { type: 'rentals',
          attributes: attributes.transform_keys { |key| key.to_s.dasherize }
        }
      }
    end

    def update_jsonapi_rental_hash(attributes, id)
      h1 = { data: { id: id } }
      create_jsonapi_rental_hash(attributes).deep_merge(h1).to_json
    end
end
