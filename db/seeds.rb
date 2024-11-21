# Clear existing products in development
if Rails.env.development?
  Product.destroy_all
  puts "Cleared existing products."
end

# Seed realistic products
product_names = 10.times.map { Faker::Commerce.product_name }.uniq
product_names.each do |name|
  Product.create!(
    name: name,
    description: Faker::Lorem.sentence(word_count: 10),
    current_price: Faker::Commerce.price(range: 5..100.0),
    stock_quantity: rand(10..50)
  )
end
puts "Seeded #{product_names.size} realistic products."

# Seed static pages
StaticPage.create!(
  title: "About Us",
  content: "Welcome to Eco Essentials! We provide sustainable products that make the planet greener. This page can be updated via the admin panel.",
  slug: "about"
)

StaticPage.create!(
  title: "Contact Us",
  content: "Have questions? Reach out to us via this page. You can update this content via the admin panel.",
  slug: "contact"
)
puts "Seeded static pages: About Us and Contact Us."
