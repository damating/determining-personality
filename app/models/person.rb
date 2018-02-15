class Person
  attr_reader :gender, :name, :surname

  def initialize(data)
    @gender = data['gender']['gender']
    @name = data['addressingGivenName']
    @surname = data['addressingSurname']
  end
end
