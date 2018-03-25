class AddressDecorator
  delegate :name, :surname, :gender,
           to: :person, allow_nil: true
  delegate :formatted_address, :place_name, :latitude, :longitude, :place_types,
           to: :@address

  attr_reader :person, :address, :address_type

  def initialize(address, person = nil)
    @person = person
    @address = address
    @address_type = @person ? 'private' : 'company'
  end
end
