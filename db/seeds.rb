# Clear existing data
puts "Clearing old data..."
Product.destroy_all

# Seed products
puts "Seeding products..."
50.times do |i|
  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    current_price: Faker::Commerce.price(range: 5..100.0),
    stock_quantity: rand(1..50)
  )
  puts "Created product #{i + 1}/50" if (i + 1) % 10 == 0 # Progress log every 10 products
end

puts "Seeding completed: 50 products added."
