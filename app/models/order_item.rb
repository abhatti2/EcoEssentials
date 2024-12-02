class OrderItem < ApplicationRecord
  # Associations
  belongs_to :order
  belongs_to :product

  # Validations
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_at_purchase, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Callbacks
  before_validation :set_price_at_purchase, on: :create

  # Helper Methods

  # Dynamically calculates the subtotal for the line item (quantity * price_at_purchase)
  def subtotal
    quantity * price_at_purchase
  end

  # Sets the price at purchase based on the current product price if not already set
  def set_price_at_purchase
    self.price_at_purchase ||= product.current_price
  end
end
