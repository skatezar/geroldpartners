# Preview all emails at http://localhost:3000/rails/mailers/job_application_mailer
class JobApplicationMailerPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/job_application_mailer/new_application
  def new_application
    JobApplicationMailer.new_application(sample_application)
  end

  # http://localhost:3000/rails/mailers/job_application_mailer/confirmation
  def confirmation
    JobApplicationMailer.confirmation(sample_application)
  end

  private

  def sample_application
    mandate = Mandate.new(title: "Chief Operating Officer", description: "Leading European fund", location: "London", active: true)
    JobApplication.new(
      mandate: mandate,
      name: "Jane Doe",
      email: "jane.doe@example.com",
      linkedin_url: "https://linkedin.com/in/janedoe"
    )
  end
end
