class PlacesFinderApi::Client
  def self.get_address_data(address_text)
    return if address_text.blank?

    address_data = CacheStore.get_or_cache_data(address_text, 30) do
      PlacesFinderApi::Request.get_address_data(address_text)
    end
    address_data = JSON.parse(address_data)
    return unless address_data['status'] == 'OK'

    address_data['results'].first
  rescue RestClient::ExceptionWithResponse => e
    raise e.response
  end
end
