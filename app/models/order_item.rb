class OrderItem < ApplicationRecord
  # Associations
  belongs_to :order
  belongs_to :product

  # Validations
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_at_purchase, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Callbacks
  before_save :calculate_subtotal

  # Attributes
  attr_accessor :subtotal

  # Helper Methods

  # Calculates the subtotal for the line item (quantity * price_at_purchase)
  def calculate_subtotal
    self.subtotal = quantity * price_at_purchase
  end

  # Convenience method for retrieving the current total for the line item
  def total
    calculate_subtotal unless subtotal
    subtotal
  end
end
