class JobApplicationMailer < ApplicationMailer
  default from: 'laurenz@geroldpartners.com'

  def new_application(job_application)
    @application = job_application
    @mandate = job_application.mandate

    # Attach CV if present
    if @application.cv.attached?
      attachments[@application.cv.filename.to_s] = @application.cv.download
    end

    mail(
      to: 'laurenz@geroldpartners.com',
      subject: "New Application for #{@mandate.title}"
    )
  end

  def confirmation(job_application)
    @application = job_application
    @mandate = job_application.mandate

    mail(
      to: @application.email,
      subject: "We received your application — #{@mandate.title}"
    )
  end
end
