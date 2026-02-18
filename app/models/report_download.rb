class ReportDownload < ApplicationRecord
  belongs_to :compensation_report

  validates :name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
