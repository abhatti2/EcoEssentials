# Clear existing products
Product.destroy_all

# Seed realistic products
10.times do
  Product.create!(
    name: Faker::Commerce.product_name, # Generates realistic product names
    description: Faker::Lorem.sentence(word_count: 10), # More descriptive text
    current_price: Faker::Commerce.price(range: 5..100.0),
    stock_quantity: rand(10..50)
  )
end
puts "Seeded 10 realistic products."
