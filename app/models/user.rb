class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_one :customer, foreign_key: :email, primary_key: :email, dependent: :destroy

  # Validations
  validates :first_name, :last_name, :address, :city, :province, :postal_code, :phone, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :postal_code, format: { with: /\A[A-Za-z]\d[A-Za-z][ ]?\d[A-Za-z]\d\z/, message: "must be a valid Canadian postal code" }
  validates :phone, format: { with: /\A[+\d]?[\d.\s()-]+\z/, message: "must be a valid phone number" }

  # Helper Methods

  # Returns the full name of the user
  def full_name
    "#{first_name} #{last_name}"
  end

  # Automatically creates or retrieves the associated customer for the user
  def ensure_customer
    customer || create_customer(
      first_name: first_name,
      last_name: last_name,
      address: address,
      city: city,
      province: province,
      postal_code: postal_code,
      phone: phone,
      email: email
    )
  end
end
