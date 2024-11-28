class Product < ApplicationRecord
  belongs_to :category, optional: true

  # Scope for searching products by query and filtering by category name
  scope :search, ->(query) {
    if query.present?
      joins(:category).where(
        "LOWER(products.name) LIKE :query OR LOWER(products.description) LIKE :query OR LOWER(categories.name) LIKE :query",
        query: "%#{query.downcase}%"
      )
    else
      all
    end
  }

  # Explicitly define ransackable attributes for ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    %w[category_id created_at current_price description id name stock_quantity updated_at]
  end

  # Define ransackable associations for category filtering
  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end
end
