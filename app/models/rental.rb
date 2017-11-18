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
    api_rental = ApiRental.new("http://localhost:3000", "SPAFOISFO2RFJ209FJ23")
    api_rental.index_rental
  end


  def self.find(id)
    api_rental = ApiRental.new("http://localhost:3000", "SPAFOISFO2RFJ209FJ23")
    api_rental.show_rental(id)
  end

  def update_attributes(attributes)
    api_rental = ApiRental.new("http://localhost:3000", "SPAFOISFO2RFJ209FJ23")
    api_rental.update_rental(attributes, self.id)
  end

  def save
    api_rental = ApiRental.new("http://localhost:3000", "SPAFOISFO2RFJ209FJ23")
    self.id = api_rental.create_rental(name, daily_rate)
  end

  def destroy
    api_rental = ApiRental.new("http://localhost:3000", "SPAFOISFO2RFJ209FJ23")
    Rental.find(id).bookings.each { |booking| booking.destroy }
    api_rental.destroy_rental(id)
  end

  def bookings
    api_rental = ApiRental.new("http://localhost:3000", "SPAFOISFO2RFJ209FJ23")
    api_rental.get_rental_bookings(id)
  end


end