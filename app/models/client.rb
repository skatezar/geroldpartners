class Client < ApplicationRecord
  has_secure_password

  belongs_to :user, optional: true
  has_many :roles, dependent: :destroy
  has_many :recommendations, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9\-]+\z/, message: "may only contain lowercase letters, numbers, and dashes" }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  before_validation :generate_slug, on: :create

  def to_param
    slug
  end

  def contact_email_list
    contact_emails.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  private

  def generate_slug
    return if slug.present?
    base = name.to_s.parameterize
    candidate = base
    n = 2
    while Client.where(slug: candidate).exists?
      candidate = "#{base}-#{n}"
      n += 1
    end
    self.slug = candidate
  end
end
