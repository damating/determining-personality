require 'rest-client'

class NameExtractor
  def self.split_words(text)
    words = text.split(' ')
    { full_name: words.shift(2).join(' '), address: words.join(' ') }
  end
end
