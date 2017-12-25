class ApiClient

  def initialize(host, api_token)
    @host = host
    @api_token = api_token
  end

  def get(path, params = {})
    response = connection.get(path, params)
    response.body
  end

  def post(path, params = {})
    response = connection.post(path, params)
    response.body
  end

  def patch(path, params = {})
    response = connection.patch(path, params)
    response.body
  end

  def delete(path)
    response = connection.delete(path)
    response.body
  end


  attr_reader :host, :api_token

  def connection
    @connection ||= Faraday.new(host) do |c|
      c.request :url_encoded
      c.adapter Faraday.default_adapter
      c.headers['Content-Type'] = 'application/vnd.api+json'
      c.authorization :Token, api_token if api_token.present?
    end
  end
end


