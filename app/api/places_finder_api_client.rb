require 'uri'

class PlacesFinderApiClient
  def self.get_address_data(address)
    request = call_by_query(address)
    data = JSON.parse(request.body)
    return unless data['status'] == 'OK'

    data['results'].first
  rescue RestClient::ExceptionWithResponse => e
    raise e.response
  end

  def self.call_by_query(address)
    encoded_address = encode_uri_params('query', address)
    RestClient.post "https://maps.googleapis.com/maps/api/place/textsearch/json?#{encoded_address}&key=#{ENV['google_places_key']}", content_type: :json, accept: :json
  end

  def self.encode_uri_params(name, value)
    URI.encode_www_form(name => value).to_s
  end
end