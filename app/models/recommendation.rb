class Recommendation < ApplicationRecord
  STATUSES = {
    "not_interviewed"     => "Not yet interviewed",
    "interviewed_round_1" => "Interviewed 1st round",
    "interviewed_round_2" => "Interviewed 2nd round",
    "rejected"            => "Rejected"
  }.freeze

  belongs_to :client
  has_one_attached :cv
  has_rich_text :description

  validates :name, presence: true
  validates :status, inclusion: { in: STATUSES.keys }
  validate :cv_content_type

  def status_label
    STATUSES[status] || STATUSES.values.first
  end

  private

  def cv_content_type
    return unless cv.attached?
    return if cv.blob.content_type == "application/pdf"
    errors.add(:cv, "must be a PDF")
  end
end
