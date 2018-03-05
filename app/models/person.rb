class Person
  attr_reader :gender, :name, :surname

  def initialize(data)
    @name = data['addressingGivenName']
    @surname = data['addressingSurname']
    @gender = data['gender']['gender']
  end
end
