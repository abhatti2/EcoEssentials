class Order < ApplicationRecord
  # Associations
  belongs_to :customer
  has_many :order_items, dependent: :destroy

  # Validations
  validates :order_date, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending completed canceled processing], message: "%{value} is not a valid status" }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :recent, -> { order(order_date: :desc) }
  scope :pending, -> { where(status: "pending") }
  scope :completed, -> { where(status: "completed") }
  scope :canceled, -> { where(status: "canceled") }
  scope :processing, -> { where(status: "processing") }

  # Callbacks
  before_validation :set_default_status, on: :create

  # Helper methods

  # Calculates the total amount for the order by summing its items
  def calculate_total
    self.total_amount = order_items.sum { |item| item.price_at_purchase * item.quantity }
  end

  # Mark the order as completed
  def complete!
    return false unless status == "processing" || status == "pending"
    update!(status: "completed", order_date: Time.current)
  end

  # Mark the order as canceled
  def cancel!
    return false unless status == "pending" || status == "processing"
    update!(status: "canceled")
  end

  private

  # Set default status to 'pending' if not already set
  def set_default_status
    self.status ||= "pending"
  end
end
