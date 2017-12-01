class Booking
  include ActiveModel::Model
  include ActiveModelAttributes

  attribute :id, :integer
  attribute :start_at, :datetime
  attribute :end_at, :datetime
  attribute :client_email, :string
  attribute :price, :decimal
  attribute :rental_id, :integer
  validates :price, :rental_id, :start_at, presence: true
  validates :end_at, date: { after_or_equal_to: Proc.new { |obj| obj.start_at } }, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :client_email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }

  def to_param
    id.to_s
  end

  def self.find(id)
    access_api.show_booking(id)
  end

  def self.all
    access_api.index_booking
  end

  def save
    access_api.create_booking(start_at, end_at, client_email, price, rental_id)
    self.valid?
  end

  def update_attributes(attributes)
    overwrite_self_attributes(attributes)
    if dates_exist?(attributes)
      attributes[:price] = booking_duration(attributes) * rental_daily_rate(rental_id)
      access_api.update_booking(attributes, id, rental_id)
    end
    self.valid?
  end

  def destroy
    access_api.destroy_booking(id)
  end

  def rental
    Rental.access_api.show_rental(rental_id)
  end

  def self.access_api
    ApiBooking.new(ENV['HOST'], ENV['API_TOKEN'])
  end

  private

    def overwrite_self_attributes(attributes)
      self.start_at = attributes[:start_at]
      self.end_at = attributes[:end_at]
      self.client_email = attributes[:client_email]
    end

    def booking_duration(attributes)
      if dates_exist?(attributes)
        (attributes[:end_at].to_date - attributes[:start_at].to_date).to_i
      end
    end

    def dates_exist?(attributes)
      (attributes[:end_at].present?) && (attributes[:start_at].present?)
    end

    def rental_daily_rate(rental_id)
      Rental.access_api.show_rental(rental_id).daily_rate
    end

    def access_api
      self.class.access_api
    end
end
