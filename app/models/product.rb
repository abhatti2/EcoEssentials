class Product < ApplicationRecord
  scope :search, ->(query) {
    if query.present?
      where("name ILIKE :query OR description ILIKE :query OR category ILIKE :query", query: "%#{query}%")
    else
      all
    end
  }
end
