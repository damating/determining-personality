class PersonalAddressDecorator
  delegate :name, :surname, :gender, to: :person, prefix: true, allow_nil: true
  delegate :formatted_address, :place_name, :latitude, :longitude, :place_types, to: :@address

  def initialize(address, person = nil)
    @person = person
    @address = address
  end

  # needed for use prefix for delegation
  def person
    @person
  end
end
