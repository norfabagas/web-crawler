require_relative "db/sqlite3_helper"

module Lib
  db = SQLite3Helper.new("product.db")
  iter = 1

  puts "===> Crawl Results"
  puts "No of products: #{db.get_from_table("products").count}"

  db.get_from_table("products").each do |product|
    puts "===> [#{iter}]"
    puts "Title: #{product['title']}"
    puts "Price: #{product['price']}"
    puts "Description: #{product['description']}"
    puts "Extra Information: #{product['extra_information']}"

    iter += 1
    puts "\n"
  end
end