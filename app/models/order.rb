class Order < ApplicationRecord
  # Associations
  belongs_to :user, optional: true # For authenticated users
  belongs_to :customer, optional: true # For guest users
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
  before_save :ensure_total_amount

  # Helper methods

  # Calculates the total amount for the order by summing its items
  def calculate_total
    self.total_amount = order_items.sum { |item| item.price_at_purchase * item.quantity }
  end

  # Calculates the total amount, including taxes, for the order
  def calculate_total_with_taxes(province, tax_rates)
    subtotal = order_items.sum { |item| item.price_at_purchase * item.quantity }
    pst = subtotal * (tax_rates[:pst] || 0.0)
    gst = subtotal * (tax_rates[:gst] || 0.0)
    hst = subtotal * (tax_rates[:hst] || 0.0)
    self.total_amount = subtotal + pst + gst + hst
  end

  # Mark the order as completed
  def complete!
    return false unless %w[processing pending].include?(status)
    update!(status: "completed", order_date: Time.current)
  end

  # Mark the order as canceled
  def cancel!
    return false unless %w[pending processing].include?(status)
    update!(status: "canceled")
  end

  private

  # Set default status to 'pending' if not already set
  def set_default_status
    self.status ||= "pending"
  end

  # Ensure total amount is calculated before saving
  def ensure_total_amount
    calculate_total if total_amount.nil? || total_amount.zero?
  end
end
