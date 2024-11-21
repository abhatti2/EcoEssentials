class Category < ApplicationRecord
  has_many :products, dependent: :nullify # Ensures products are not deleted when a category is removed

  # Validations for data integrity
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # Define ransackable attributes for ActiveAdmin search functionality
  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at]
  end

  # Define ransackable associations
  def self.ransackable_associations(auth_object = nil)
    %w[products]
  end

  # Optional helper method for displaying the category name
  def display_name
    name.titleize
  end
end
