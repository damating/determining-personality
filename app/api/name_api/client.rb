class NameApi::Client
  def self.get_person_data_by_fullname(fullname)
    return if fullname.blank?

    person = CacheStore.get_or_cache_data(fullname, 30) do
      data = NameApi::Request.get_person_data_by_fullname(fullname)
      data = JSON.parse(data)
      data = data['matches'].select { |match| match['likeliness'] > 0.7 }
                            .sort_by { |match| match['likeliness'] }
                            .last
      data['parsedPerson'].to_json if data.present?
    end
    return unless person.present?

    JSON.parse(person)
  rescue RestClient::ExceptionWithResponse => e
    raise e.response
  end
end
