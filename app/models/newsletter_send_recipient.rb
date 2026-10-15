class NewsletterSendRecipient < ApplicationRecord
  belongs_to :newsletter_send

  STATUSES = %w[pending sent failed].freeze

  validates :email, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :pending, -> { where(status: "pending") }
  scope :sent,    -> { where(status: "sent") }
  scope :failed,  -> { where(status: "failed") }
end
