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

StaticPage.create!(
  title: "About Us",
  content: "This is the About Us page. Edit this content via the admin panel.",
  slug: "about"
)

StaticPage.create!(
  title: "Contact Us",
  content: "This is the Contact Us page. Edit this content via the admin panel.",
  slug: "contact"
)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?