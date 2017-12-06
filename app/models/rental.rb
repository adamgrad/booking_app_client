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
    access_api.index_rental
  end

  def self.find(id)
    access_api.show_rental(id)
  end

  def update_attributes(attributes)
    overwrite_self_attributes(attributes)
    access_api.update_rental(self.id, attributes)
    self.valid?
  end

  def save
    self.id = access_api.create_rental(name, daily_rate)
    self.valid?
  end

  def destroy
    Rental.find(id).bookings.each { |booking| booking.destroy }
    access_api.destroy_rental(id)
  end

  def bookings
    access_api.get_rental_bookings(id)
  end

  def self.access_api
    ApiRental.new(ENV['HOST'], ENV['API_TOKEN'])
  end

  private

    def overwrite_self_attributes(attributes)
      self.name = attributes[:name]
      self.daily_rate = attributes[:daily_rate]
    end

    def access_api
      self.class.access_api
    end
end
