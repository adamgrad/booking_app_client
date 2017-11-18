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
    api_client = ApiClient.new
    api_client.index_rental
  end

  def self.find(id)
    api_client = ApiClient.new
    api_client.show_rental(id)
  end

  def update_attributes(attributes)
    api_client = ApiClient.new
    api_client.update_rental(attributes, self.id)
  end

  def save
    api_client = ApiClient.new
    self.id = api_client.create_rental(name, daily_rate)
  end

  def destroy
    api_client = ApiClient.new
    Rental.find(id).bookings.each { |booking| booking.destroy }
    api_client.destroy_rental(id)
  end

  def bookings
    api_client = ApiClient.new
    api_client.get_rental_bookings(id)
  end


end