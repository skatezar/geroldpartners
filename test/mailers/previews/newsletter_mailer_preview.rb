# Preview all emails at http://localhost:3000/rails/mailers/newsletter_mailer
class NewsletterMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/newsletter_mailer/confirmation_email
  def confirmation_email
    NewsletterMailer.confirmation_email
  end

  # Preview this email at http://localhost:3000/rails/mailers/newsletter_mailer/daily_digest
  def daily_digest
    NewsletterMailer.daily_digest
  end
end
