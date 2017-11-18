class Booking
  include ActiveModel::Model
  include ActiveModelAttributes

  attribute :id, :integer
  attribute :start_at, :datetime
  attribute :end_at, :datetime
  attribute :client_email, :string
  attribute :price, :decimal
  attribute :rental_id, :integer

  def to_param
    id.to_s
  end

  def self.all
    api_client = ApiClient.new
    api_client.index_booking
  end

  def save
    api_client = ApiClient.new
    api_client.create_booking(start_at, end_at, client_email, price, rental_id)
  end

  def destroy
    api_client = ApiClient.new
    api_client.destroy_booking(id)
  end

  def self.find(id)
    api_client = ApiClient.new
    api_client.show_booking(id)
  end

end