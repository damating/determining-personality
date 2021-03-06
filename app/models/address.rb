class Address
  attr_reader :formatted_address, :latitude, :longitude, :place_types, :place_name

  def initialize(data)
    @formatted_address = data['formatted_address']
    @latitude = data['geometry']['location']['lat']
    @longitude = data['geometry']['location']['lng']
    @place_types = data['types'].join(' ')
    @place_name = data['name']
  end
end
