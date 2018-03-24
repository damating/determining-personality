require 'uri'

module ApiHelper
  def encode_uri_params(name, value)
    URI.encode_www_form(name => value).to_s
  end
end
