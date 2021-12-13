require_relative "crawler"

module Lib
  100.times do # loop the product (because some products don't have any recommendations)
    
    url = ARGV[1].nil? ? "https://magento-test.finology.com.my/breathe-easy-tank.html" : ARGV[1].to_s
    n_of_duplicates_found = ARGV[2].nil? ? 10 : ARGV[2].to_i
    tries = 0
  
    # loop through product & related product url
    while tries <= n_of_duplicates_found
      crawler = Crawler.new(url)
      result = crawler.run
  
      # no more product recommendations
      if result.nil?
        puts "==> no more product recommendation(s)"
        break
      end
    
      # process information retrieved
      if result[:is_duplicate]
        tries = tries + 1
        puts "==> duplicate count: #{tries}"
      end
  
      url = result[:next_url] # get next related url
    end

  end
end