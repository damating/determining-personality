class PlacesFinderApi::Client
  def self.get_address_data(address)
    data = CacheStore.get_or_cache_data(address, 30) do
      PlacesFinderApi::Request.get_address_data(address)
    end
    data = JSON.parse(data)
    return unless data['status'] == 'OK'

    data['results'].first
  rescue RestClient::ExceptionWithResponse => e
    raise e.response
  end
end
