class AddressEnricher
  def get_result(plain_address_text)
    fullname_with_address = NameExtractor.split_words(plain_address_text)

    person = get_person_details(fullname_with_address[:full_name])

    if person
      address = get_address_details(fullname_with_address[:address])
      PersonalAddressDecorator.new(address, person)
    else
      address = get_address_details(plain_address_text)
      PersonalAddressDecorator.new(address)
    end
  end

  private

  def get_person_details(full_name)
    raw_person_details = NameApiClient.get_person_data_by_fullname(full_name)
    return false unless raw_person_details

    Person.new(raw_person_details)
  rescue StandardError => _e
    raise 'Something went wrong while receiving personal data.'
  end

  def get_address_details(address)
    raw_address_details = PlacesFinderApiClient.get_address_data(address)
    return false unless raw_address_details

    Address.new(raw_address_details)
  rescue StandardError => _e
    raise 'Something went wrong while receiving address data.'
  end
end
