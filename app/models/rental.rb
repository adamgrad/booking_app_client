class Rental
  include ActiveModel::Model
  include ActiveModelAttributes

  attribute :id, :integer
  attribute :name, :string
  attribute :daily_rate, :decimal
  validates :name, presence: true
  validates :daily_rate, presence: true

  def to_param
    id.to_s
  end

  def self.all
    Rental.access_api.index_rental
  end

  def self.find(id)
    Rental.access_api.show_rental(id)
  end

  def update_attributes(attributes)
    Rental.access_api.update_rental(self.id, attributes)
  end

  def save
    api_response = Rental.access_api.create_rental(name, daily_rate)
    api_response ? self.id = api_response : false
  end

  def destroy
    Rental.find(id).bookings.each { |booking| booking.destroy }
    Rental.access_api.destroy_rental(id)
  end

  def bookings
    Rental.access_api.get_rental_bookings(id)
  end

  private

    def self.access_api
      ApiRental.new(ENV['HOST'], ENV['API_TOKEN'])
    end
end
