class Recommendation < ApplicationRecord
  belongs_to :client
  has_one_attached :cv

  validates :name, presence: true
  validate :cv_content_type

  private

  def cv_content_type
    return unless cv.attached?
    return if cv.blob.content_type == "application/pdf"
    errors.add(:cv, "must be a PDF")
  end
end
