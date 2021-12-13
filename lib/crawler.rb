require 'nokogiri'
require 'net/http'
require 'uri'

require_relative 'services/crawler_service'
require_relative 'db/sqlite3_helper'

class Crawler

  def initialize(base_url)
    @base_url = base_url
    @table_name = "products"
    @db = initialize_product_db
    create_product_table
  end

  def run
    # initialize required variables
    url = @base_url
    is_duplicate = false

    if url.empty?
      return nil
    else
      # initialize nokogiri object (document)
      doc = CrawlerService::crawl(url)
  
      # store crawled result
      product = product_hash(
        url,
        CrawlerService::get_title(doc),
        CrawlerService::get_price(doc),
        CrawlerService::get_description(doc),
        CrawlerService::get_extra_information(doc)
      )
  
      next_url = CrawlerService::get_next_url(doc)
  
      # Output the result to console
      print_to_console(product, is_duplicate)
              
      # Check for data duplication and insert to db
      if search_product(url)
        is_duplicate = true
        puts "==> Product #{url} not saved to database (duplicate) <===\n"
      else
        insert_new_product(product)
      end  
  
      return {
        next_url: next_url,
        is_duplicate: is_duplicate
      }
    end
  end

  private
  
  def product_hash(url, title, price, description, extra_information)
    {
      url: url, 
      title: title, 
      price: price, 
      description: description, 
      extra_information: extra_information
    }
  end
  
  def print_to_console(product, is_duplicate)
    puts "\n==> Retrieved from: #{product[:url]}"
    
    unless is_duplicate
      puts "Name: #{product[:title]}"
      puts "Price: #{product[:price]}"
      puts "Description: #{product[:description]}"
      puts "Extra Information: #{product[:extra_information]}"
    else
      puts "Product is already stored to db"  
    end
    
    puts "=====\n"
  end

  def create_product_table
    @db.create_table(@table_name, {
      "url": "text",
      "title": "text",
      "price": "text",
      "description": "text",
      "extra_information": "text"
    })
  end

  def drop_product_table
    @db.drop_table("products")
  end

  def initialize_product_db
    return SQLite3Helper.new("product.db")
  end

  def insert_new_product(product)
    @db.insert_into_table(@table_name, product)
  end

  def get_all_products
    @db.get_from_table(@table_name)
  end

  def search_product(url)
    @db.find_from_table(@table_name, "url", url)
  end

end  