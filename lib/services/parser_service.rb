require 'nokogiri'

module ParserService
  def self.parse(http_response)
    Nokogiri::HTML5(http_response)
  end
end