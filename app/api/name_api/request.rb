class NameApi::Request
  def self.get_person_data_by_fullname(fullname)
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
