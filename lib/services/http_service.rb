require 'uri'
require 'net/http'

module HTTPService
  def self.generate_uri(url)
    URI(url.to_s)
  end

  def self.get_response(uri)
    Net::HTTP.get(uri)
  end
end