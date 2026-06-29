class Recommendation < ApplicationRecord
  STATUSES = {
    "not_interviewed"     => "Not yet interviewed",
    "interviewed_round_1" => "Interviewed 1st round",
    "interviewed_round_2" => "Interviewed 2nd round",
    "rejected"            => "Rejected"
  }.freeze

  belongs_to :client
  belongs_to :role, optional: true
  has_one_attached :cv
  has_rich_text :description

  before_create :generate_availability_token

  validates :name, presence: true
  validates :status, inclusion: { in: STATUSES.keys }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validate :cv_content_type

  def status_label
    STATUSES[status] || STATUSES.values.first
  end

  def availability_slots_parsed
    return [] if availability_slots.blank?
    JSON.parse(availability_slots)
  rescue JSON::ParserError
    []
  end

  private

  def generate_availability_token
    self.availability_token ||= SecureRandom.urlsafe_base64(24)
  end

  def cv_content_type
    return unless cv.attached?
    return if cv.blob.content_type == "application/pdf"
    errors.add(:cv, "must be a PDF")
  end
end
