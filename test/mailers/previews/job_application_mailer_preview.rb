# Preview all emails at http://localhost:3000/rails/mailers/job_application_mailer
class JobApplicationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/job_application_mailer/new_application
  def new_application
    JobApplicationMailer.new_application
  end
end
