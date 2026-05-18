class NewsletterMailer < ApplicationMailer
  def confirmation_email(subscription)
    @subscription = subscription
    @confirmation_url = confirm_newsletter_subscriptions_url(token: subscription.confirmation_token)

    mail(
      to: subscription.email,
      subject: 'Confirm Your Newsletter Subscription - Gerold & Partners'
    )
  end

  def daily_digest(new_subscriptions)
    @new_subscriptions = new_subscriptions
    @date = Date.yesterday

    mail(
      to: 'laurenz@geroldpartners.com',
      subject: "New Newsletter Subscriptions - #{@date.strftime('%B %d, %Y')}"
    )
  end

  def admin_notification(subscription)
    @subscription = subscription

    mail(
      to: 'laurenz@geroldpartners.com',
      subject: 'New Newsletter Subscription'
    )
  end
end
