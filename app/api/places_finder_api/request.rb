class PlacesFinderApi::Request
  extend ApiHelper

  def self.get_address_data(address)
    encoded_address = encode_uri_params('query', address)
    RestClient.post "https://maps.googleapis.com/maps/api/place/textsearch/json?#{encoded_address}&key=#{ENV['google_places_key']}",
                    content_type: :json, accept: :json
  end
end
