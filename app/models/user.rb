class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :first_name, :last_name, :address, :city, :province, :postal_code, :phone, presence: true
  validates :postal_code, format: { with: /\A[A-Za-z]\d[A-Za-z][ ]?\d[A-Za-z]\d\z/, message: "must be a valid Canadian postal code" }
  validates :phone, format: { with: /\A[+\d]?[\d.\s()-]+\z/, message: "must be a valid phone number" }

  # Helper Methods
  def full_name
    "#{first_name} #{last_name}"
  end
end
