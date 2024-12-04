class Customer < ApplicationRecord
  # Associations
  has_many :orders, dependent: :destroy

   # Validations
   validates :first_name, :last_name, :address, :city, :postal_code, :phone, :province, presence: true
   validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
   validates :postal_code, format: { with: /\A[A-Za-z]\d[A-Za-z][ ]?\d[A-Za-z]\d\z/, message: "must be a valid Canadian postal code" }
   validates :phone, format: { with: /\A[+\d]?[\d.\s()-]+\z/, message: "must be a valid phone number" }
   validates :province, presence: true, on: :tax_calculation # Custom validation context for tax calculation

  # Helper method for full name
  def full_name
    "#{first_name} #{last_name}"
  end

  # Check if the customer is a guest
  def guest_user?
    !User.exists?(email: email)
  end

  # Retrieve recent address details for the customer
  def recent_address
    orders.last&.address || address
  end

  def recent_province
    orders.last&.province || province
  end
end
