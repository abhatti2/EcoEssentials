class Customer < ApplicationRecord
  # Associations
  has_many :orders, dependent: :destroy

  # Validations
  validates :first_name, :last_name, :email, :address, :city, :postal_code, :phone, :province, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :postal_code, format: { with: /\A[A-Za-z]\d[A-Za-z][ ]?\d[A-Za-z]\d\z/, message: "must be a valid Canadian postal code" }
  validates :phone, format: { with: /\A[+\d]?[\d.\s()-]+\z/, message: "must be a valid phone number" }

  # Full name helper method
  def full_name
    "#{first_name} #{last_name}"
  end
end
