require 'uri'

class PlacesFinderApi
  def self.find_address(address)
    request = fetch_address_data_by_query(address)
    data = JSON.parse(request.body)
    return data['results'].first if data['status'] == 'OK'

    raise 'Address not found!'
  end

  def self.fetch_address_data_by_query(address)
    encoded_address = encode_uri_params('query', address)
    RestClient.post "https://maps.googleapis.com/maps/api/place/textsearch/json?#{encoded_address}&key=#{ENV['google_places_key']}", content_type: :json, accept: :json
  end

  def self.encode_uri_params(name, value)
    URI.encode_www_form(name => value).to_s
  end
end
