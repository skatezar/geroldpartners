class JobApplicationMailer < ApplicationMailer
  default from: 'laurenz@geroldpartners.com'

  def new_application(job_application)
    @application = job_application
    @mandate = job_application.mandate

    mail(
      to: 'laurenz@geroldpartners.com',
      subject: "New Application for #{@mandate.title}"
    )
  end
end
