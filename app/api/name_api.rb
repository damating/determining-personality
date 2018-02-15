class NameApi
  def self.get_person_data_by_fullname(full_name)
    request = by_fullname(full_name)

    data = JSON.parse(request.body)
    data = data['matches'].select { |match| match['likeliness'] > 0.7 }.first # TO DO choose the one which has the biggest likeliness
    return false unless data

    data['parsedPerson']
  rescue StandardError => e
    # 500 Internal Server Error
    puts e
  end

  def self.fetch_person_data_by_fullname(full_name)
    RestClient.post "http://rc50-api.nameapi.org/rest/v5.0/parser/personnameparser?apiKey=#{ENV['name_api_key']}",
                    {
                      'inputPerson' =>
                      {
                        'type' => 'NaturalInputPerson',
                        'personName' =>
                        {
                          'nameFields' =>
                          [
                            { 'string' => "#{full_name}", 'fieldType' => 'FULLNAME' }
                          ]
                        }
                      }
                    }.to_json,
                    { content_type: :json, accept: :json }
  end
end
