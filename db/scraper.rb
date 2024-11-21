require 'nokogiri'
require 'open-uri'

# URL of the website to scrape
BASE_URL = "https://example.com"

# Fetch and parse HTML document
doc = Nokogiri::HTML(URI.open("#{BASE_URL}/categories"))

puts "Starting data scraping..."

# Clear existing data
Category.destroy_all
Product.destroy_all

# Scrape categories and their products
doc.css(".category").each do |category_section|
  # Extract category name
  category_name = category_section.at_css(".category-name").text.strip

  # Create category
  category = Category.create!(name: category_name)

  puts "Created category: #{category_name}"

  # Extract products under the category
  category_section.css(".product").each do |product_section|
    product_name = product_section.at_css(".product-name").text.strip
    product_description = product_section.at_css(".product-description").text.strip
    product_price = product_section.at_css(".product-price").text.strip.gsub("$", "").to_f
    product_stock = rand(10..50) # Simulate stock data

    # Create product
    Product.create!(
      name: product_name,
      description: product_description,
      current_price: product_price,
      stock_quantity: product_stock,
      category: category
    )

    puts "  - Added product: #{product_name}"
  end
end

puts "Data scraping and seeding completed!"
