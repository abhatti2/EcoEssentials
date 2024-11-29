class OrderItem < ApplicationRecord
  # Associations
  belongs_to :order
  belongs_to :product

  # Validations
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Callbacks
  before_save :calculate_subtotal

  # Helper Methods

  # Calculates the subtotal for the line item (quantity * unit_price)
  def calculate_subtotal
    self.subtotal = quantity * unit_price
  end
end
