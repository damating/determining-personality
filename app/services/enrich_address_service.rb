class EnrichAddressService
  def initialize(**args)
    @plain_address_text = args[:plain_address_text]
  end

  def call
    full_name, personal_address_text = extract_name_and_address
    return unless personal_address_text.present?

    person = get_person_by_fullname(full_name)
    address = if person.is_a?(Person)
                get_address(personal_address_text)
              else
                get_address(@plain_address_text)
              end

    return unless address.is_a?(Address)
    AddressDecorator.new(address, person)
  end

  private

  def extract_name_and_address
    fullname_with_address = ExtractNameAndAddressService.new(text: @plain_address_text).call
    return fullname_with_address[:full_name], fullname_with_address[:address]
  end

  def get_person_by_fullname(full_name)
    person_details = find_person_by_fullname(full_name)
    return unless person_details.present?

    Person.new(person_details)
  end

  def find_person_by_fullname(full_name)
    person_details = NameApi::Client.get_person_data_by_fullname(full_name)
    return unless person_details

    person_details
  rescue StandardError => _e
    raise 'Something went wrong while receiving personal data.'
  end

  def get_address(address_text)
    address_details = find_address(address_text)
    return unless address_details.present?

    Address.new(address_details)
  end

  def find_address(address_text)
    address_details = PlacesFinderApi::Client.get_address_data(address_text)
    return unless address_details

    address_details
  rescue StandardError => _e
    raise 'Something went wrong while receiving address data.'
  end
end
