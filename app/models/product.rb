class Product < ApplicationRecord
  scope :search, ->(query) {
    where("name ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%") if query.present?
  }
end
