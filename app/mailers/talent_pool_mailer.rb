class TalentPoolMailer < ApplicationMailer
  default from: 'laurenz@geroldpartners.com'

  def new_application(talent_pool_application)
    @application = talent_pool_application

    # Attach CV if present
    if @application.cv.attached?
      attachments[@application.cv.filename.to_s] = @application.cv.download
    end

    mail(
      to: 'laurenz@geroldpartners.com',
      subject: 'New Talent Pool Application'
    )
  end
end
