class NewsletterDailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    # Get all subscriptions confirmed yesterday
    yesterday = Date.yesterday
    new_subscriptions = NewsletterSubscription.confirmed
                                              .where('DATE(confirmed_at) = ?', yesterday)
                                              .order(confirmed_at: :asc)

    # Send digest email even if there are no new subscriptions
    NewsletterMailer.daily_digest(new_subscriptions).deliver_now
  end
end
