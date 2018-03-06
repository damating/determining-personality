class NameApiClient
  def self.get_person_data_by_fullname(fullname)
    data = CacheStore.get_or_cache_data(fullname, 30) do
      call_with_fullname(fullname)
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

  def self.call_with_fullname(fullname)
    RestClient.post "http://rc50-api.nameapi.org/rest/v5.0/parser/personnameparser?apiKey=#{ENV['name_api_key']}",
                    {
                      'inputPerson' =>
                      {
                        'type' => 'NaturalInputPerson',
                        'personName' =>
                        {
                          'nameFields' =>
                          [
                            { 'string' => "#{fullname}", 'fieldType' => 'FULLNAME' }
                          ]
                        }
                      }
                    }.to_json,
                    { content_type: :json, accept: :json }
  end
end
