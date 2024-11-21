class Product < ApplicationRecord
  belongs_to :category, optional: true

  scope :search, ->(query) {
    if query.present?
      joins(:category).where(
        "products.name ILIKE :query OR products.description ILIKE :query OR categories.name ILIKE :query",
        query: "%#{query}%"
      )
    else
      all
    end
  }

  # Explicitly define ransackable attributes for ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    %w[category_id created_at current_price description id name stock_quantity updated_at]
  end

  # Optional: Define ransackable associations if necessary
  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end
end
