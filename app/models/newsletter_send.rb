class NewsletterSend < ApplicationRecord
  has_many :newsletter_send_recipients, dependent: :destroy

  STATUSES = %w[draft sending completed failed].freeze
  TEMPLATES = %w[blank blog_credit_md_2026].freeze

  validates :subject, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :recent, -> { order(created_at: :desc) }

  def draft?    = status == "draft"
  def sending?  = status == "sending"
  def completed? = status == "completed"
  def failed?   = status == "failed"

  def progress_percent
    return 0 if total_recipients.zero?
    ((sent_count + failed_count).to_f / total_recipients * 100).round
  end
end
