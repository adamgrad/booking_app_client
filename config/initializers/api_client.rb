class ApiClient
  attr_reader :faraday

  def initialize
    @faraday = Faraday.new( url: 'http://localhost:3000')  #, :headers => {"Content-Type" => "application/json"}
  end

  # Rentals

  def create_rental(name, daily_rate)
    response = faraday.post do |req|
      req.url '/rentals'
      req.headers['Content-Type'] = 'application/vnd.api+json'
      req.body = create_jsonapi_rental_hash("rental", { name: name, daily_rate: daily_rate } ).to_json
    end
    JSON(response.body)["data"]["id"]
  end

  def update_rental(attributes, id)
    faraday.patch "/rentals/#{id}" do |req|
      req.headers['Content-Type'] = 'application/vnd.api+json'
      req.body = update_jsonapi_rental_hash("rental", attributes, id).to_json
    end
  end

  def index_rental
    # JSON.parse(response)["data"].map { |resource_hash| Model.new(resource_hash["attributes"].transform_keys { |key| key.underscore }) }
    response = faraday.get '/rentals'
    JSON(response.body)["data"].map do |resource_hash|
      Rental.new({ id: resource_hash["id"]}.merge!(resource_hash["attributes"].transform_keys { |key| key.underscore }))
    end
  end

  def show_rental(id)
    response = faraday.get "/rentals/#{id}"
    attributes = JSON(response.body).fetch("data").fetch("attributes").transform_keys { |key| key.underscore }
    attributes[:id] = id
    # Rental.new(JSON(response.body)["data"]["attributes"].transform_keys { |key| key.underscore })
    Rental.new(attributes)
  end

  def destroy_rental(id)
    faraday.delete "/rentals/#{id}"
  end

  def get_rental_bookings(rental_id)
    response = faraday.get "/rentals/#{rental_id}"
    rental_data = JSON(response.body)
    bookings_link = rental_data["data"]["relationships"]["bookings"]["links"]["related"]
    bookings_data = Faraday.get bookings_link
    JSON(bookings_data.body)["data"].map do |resource_hash|
      Booking.new({ id: resource_hash["id"] }.merge!(resource_hash["attributes"].transform_keys { |key| key.underscore }.merge!({rental_id: rental_id}) ))
    end
  end

  def create_jsonapi_rental_hash(resource, attributes)
    {
        data: {
            type: resource.to_s.pluralize,
            attributes: attributes.transform_keys { |key| key.to_s.dasherize }
        }
    }
  end

  def update_jsonapi_rental_hash(resource, attributes, id)
    {
        data: {
            type: resource.to_s.pluralize,
            id: id,
            attributes: attributes.transform_keys { |key| key.to_s.dasherize }
        }
    }
  end

  # Bookings

  def create_booking(start_at, end_at, client_email, price, rental_id)
    response = faraday.post do |req|
      req.url '/bookings'
      req.headers['Content-Type'] = 'application/vnd.api+json'
      req.body = create_jsonapi_booking_hash("booking", "rental", { start_at: start_at, end_at: end_at, client_email: client_email, price: price }, rental_id ).to_json
    end
    #JSON(response.body)["data"]["id"]
  end

  def show_booking(id)
    response = faraday.get "/bookings/#{id}"
    attributes = JSON(response.body).fetch("data").fetch("attributes").transform_keys { |key| key.underscore }
    attributes[:id] = id
    Booking.new(attributes)
  end

  def index_booking
    response_booking = faraday.get '/bookings'
    JSON(response_booking.body)["data"].map do |resource_hash|
      rental_link = resource_hash["relationships"]["rental"]["links"]["related"]
      response_rental = Faraday.new(rental_link).get.body
      rental_id = JSON(response_rental)["data"]["id"]
      Booking.new({ id: resource_hash["id"] }.merge!(resource_hash["attributes"].transform_keys { |key| key.underscore }.merge!({rental_id: rental_id}) ))
    end
  end

  def destroy_booking(id)
    faraday.delete "/bookings/#{id}"
  end

  def create_jsonapi_booking_hash(resource, relationship, attributes, rental_id)
    { data:
          { type: resource.to_s.pluralize,
            relationships:
                { relationship.to_sym =>
                      { data:
                            { type: relationship.to_s.pluralize, id: rental_id} } },
            attributes: attributes.transform_keys { |key| key.to_s.dasherize }
          }
    }
  end
end

api_client = ApiClient.new