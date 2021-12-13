require 'nokogiri'

require_relative 'http_service'
require_relative 'parser_service'

module CrawlerService

  def self.crawl(url)
    uri = HTTPService::generate_uri(url)
    response = HTTPService::get_response(uri)
    doc = ParserService::parse(response)
    return doc
  end

  def self.get_title(doc)
    doc.title
  end

  def self.get_price(doc)
    doc.xpath('//span').css('.price')[0].text
  end

  def self.get_description(doc)
    doc.xpath('//div').css('.product .attribute').css('.value').text
  end

  def self.get_extra_information(doc)
    extra_information = ""

    # parse extra information table
    parsed_table = doc.xpath('//table').css('#product-attribute-specs-table').xpath('//tbody').xpath('//tr')
    parsed_table.each_with_index do |x, index|
      extra_information += "#{x.at('th').text}: #{x.at('td').text}"
      
      if index != parsed_table.size - 1
        extra_information += " | "
      end
    end

    return extra_information
  end

  def self.get_next_url(doc)
    # count all related links (e.g. 0 or 8)
    related_urls_count = doc.css('.product-item-photo').count
    
    # randomly take one of the url (e.g. url #1 or url #5)
    arr_to_get = 0
    if related_urls_count > 1
      arr_to_get = rand(0..related_urls_count - 1)
    end

    if related_urls_count > 0 # product has related link(s)
      return doc.css('.product-item-photo')[arr_to_get].attributes.first[1].value
    else # product doesn't have any related link(s)
      return ""
    end
  end

end