class ExtractNameAndAddressService
  def initialize(**args)
    @text = args[:text]
  end

  def call
    words = @text.split(' ')
    { full_name: words.shift(2).join(' '), address: words.join(' ') }
  end
end
