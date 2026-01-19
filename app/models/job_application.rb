class JobApplication < ApplicationRecord
  self.table_name = 'applications'

  belongs_to :mandate
  has_one_attached :cv

  validates :name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :cv_or_linkedin_present

  private

  def cv_or_linkedin_present
    if cv.blank? && linkedin_url.blank?
      errors.add(:base, 'Either CV or LinkedIn URL must be provided')
    end
  end
end
