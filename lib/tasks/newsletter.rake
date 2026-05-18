namespace :newsletter do
  desc "Send daily digest of new newsletter subscriptions to admin"
  task send_daily_digest: :environment do
    puts "Sending daily newsletter digest..."
    NewsletterDailyDigestJob.perform_now
    puts "Daily digest sent successfully!"
  end
end
