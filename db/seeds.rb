# Clear existing data
Category.destroy_all
Product.destroy_all

puts "Existing data cleared."

# Create 4 categories
categories = []
category_names = [ "Eco-Friendly", "Reusable", "Recyclable", "Organic" ]
category_names.each do |name|
  categories << Category.create!(name: name)
end

puts "Created #{categories.size} categories."

# Seed 100 products across the 4 categories
100.times do
  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    current_price: Faker::Commerce.price(range: 5..100.0, as_string: false),
    stock_quantity: rand(10..50),
    category: categories.sample
  )
end

puts "Seeded 100 products across #{categories.size} categories."
