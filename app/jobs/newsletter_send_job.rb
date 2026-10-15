class NewsletterSendJob < ApplicationJob
  queue_as :default

  BATCH_SIZE = 20
  BATCH_DELAY_SECONDS = 30

  def perform(newsletter_send_id)
    send = NewsletterSend.find(newsletter_send_id)
    return unless send.sending?

    pending = send.newsletter_send_recipients.pending.order(:id)

    pending.each_slice(BATCH_SIZE).with_index do |batch, index|
      sleep(BATCH_DELAY_SECONDS) if index > 0

      # Re-check status before each batch in case it was cancelled
      send.reload
      break unless send.sending?

      batch.each do |recipient|
        begin
          NewsletterMailer.broadcast(recipient.email, send.subject, send.body).deliver_now
          recipient.update!(status: "sent", sent_at: Time.current)
          send.increment!(:sent_count)
        rescue => e
          recipient.update!(status: "failed", error_message: e.message.truncate(255))
          send.increment!(:failed_count)
        end
      end
    end

    send.reload
    remaining = send.newsletter_send_recipients.pending.count
    send.update!(
      status: remaining.zero? ? "completed" : "failed",
      completed_at: Time.current
    )
  end
end
