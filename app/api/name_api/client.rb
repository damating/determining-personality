class NameApi::Client
  def self.get_person_data_by_fullname(fullname)
    data = CacheStore.get_or_cache_data(fullname, 30) do
      NameApi::Request.get_person_data_by_fullname(fullname)
    end
    data = JSON.parse(data)
    data = data['matches'].select { |match| match['likeliness'] > 0.7 }
                          .sort_by { |match| match['likeliness'] }
                          .last

    return false unless data

    data['parsedPerson']
  rescue RestClient::ExceptionWithResponse => e
    raise e.response
  end
end
