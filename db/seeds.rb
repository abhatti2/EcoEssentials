# Clear existing data in development
if Rails.env.development?
  Product.destroy_all
  Category.destroy_all
  puts "Cleared existing products and categories."
end

# Seed categories
categories = [ "Eco-Friendly", "Recyclable", "Organic", "Reusable", "Energy Efficient" ]
categories.each do |category_name|
  Category.create!(name: category_name)
end
puts "Seeded categories: #{categories.join(', ')}."

# Seed realistic products and assign them to random categories
product_names = 10.times.map { Faker::Commerce.product_name }.uniq
product_names.each do |name|
  Product.create!(
    name: name,
    description: Faker::Lorem.sentence(word_count: 10),
    current_price: Faker::Commerce.price(range: 5..100.0),
    stock_quantity: rand(10..50),
    category: Category.order("RANDOM()").first # Assign a random category
  )
end
puts "Seeded #{product_names.size} realistic products with categories."
