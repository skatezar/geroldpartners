# Preview all emails at http://localhost:3000/rails/mailers/talent_pool_mailer
class TalentPoolMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/talent_pool_mailer/new_application
  def new_application
    TalentPoolMailer.new_application
  end
end
