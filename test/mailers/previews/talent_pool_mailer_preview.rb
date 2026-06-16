# Preview all emails at http://localhost:3000/rails/mailers/talent_pool_mailer
class TalentPoolMailerPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/talent_pool_mailer/new_application
  def new_application
    TalentPoolMailer.new_application(sample_application)
  end

  # http://localhost:3000/rails/mailers/talent_pool_mailer/confirmation
  def confirmation
    TalentPoolMailer.confirmation(sample_application)
  end

  private

  def sample_application
    TalentPoolApplication.new(
      name: "Jane Doe",
      email: "jane.doe@example.com",
      phone: "+44 20 1234 5678"
    )
  end
end
