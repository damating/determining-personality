class EnrichAddressService
  def initialize(**args)
    @plain_address_text = args[:plain_address_text]
  end

  def call
    fullname_with_address = extract_name_and_address
    person = find_person_by_fullname(fullname_with_address[:full_name])

    if person.present?
      get_personal_address(fullname_with_address[:address], person)
    else
      get_place_address_from_text
    end
  end

  private

  def extract_name_and_address
    ExtractNameAndAddressService.new(text: @plain_address_text).call
  end

  def find_person_by_fullname(full_name)
    person_details = NameApi::Client.get_person_data_by_fullname(full_name)
    return false unless person_details

    Person.new(person_details)
  rescue StandardError => _e
    raise 'Something went wrong while receiving personal data.'
  end

  def get_personal_address(address_text, person)
    address = find_address(address_text)
    PersonalAddressDecorator.new(address, person)
  end

  def get_place_address_from_text
    address = find_address(@plain_address_text)
    PersonalAddressDecorator.new(address)
  end

  def find_address(address_text)
    address_details = PlacesFinderApi::Client.get_address_data(address_text)
    return false unless address_details

    Address.new(address_details)
  rescue StandardError => _e
    raise 'Something went wrong while receiving address data.'
  end
end
