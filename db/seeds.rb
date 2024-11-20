# Clear existing data
Product.destroy_all

# Create sample products
50.times do
  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph,
    current_price: Faker::Commerce.price(range: 5..100.0),
    stock_quantity: rand(1..50)
  )
end
puts "Seeded 50 products."
