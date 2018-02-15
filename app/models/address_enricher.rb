class AddressEnricher
  attr_reader :address_details, :person_details

  def initialize(plain_address_text)
    @plain_address_text = plain_address_text
  end

  def get_result
    fullname_with_address = NameExtractor.split_words(@plain_address_text)

    if get_person_details(fullname_with_address[:full_name])
      get_address_details(fullname_with_address[:address])
    else
      get_address_details(@plain_address_text)
    end
  end

  def get_person_details(full_name)
    raw_person_details = NameApi.get_person_data_by_fullname(full_name)
    return false unless raw_person_details

    @person_details = Person.new(raw_person_details)
    raw_person_details
  end

  def get_address_details(address)
    raw_address_details = PlacesFinderApi.find_address(address)
    @address_details = Address.new(raw_address_details)
  rescue StandardError => e
    puts e
  end
end
