class StaticPage < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true

  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  # Scopes
  scope :by_slug, ->(slug) { find_by(slug: slug) }

  private

  # Generates a slug from the title if not provided
  def generate_slug
    self.slug = title.parameterize
  end
end
