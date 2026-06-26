class RecommendationsMailer < ApplicationMailer
  default from: 'laurenz@geroldpartners.com'

  def interview_request(recommendation)
    @recommendation = recommendation
    @client = recommendation.client

    mail(
      to: @recommendation.email,
      cc: 'laurenz@geroldpartners.com',
      reply_to: 'laurenz@geroldpartners.com',
      subject: "Interview request — #{@client.name}"
    )
  end

  def send_to_client(recommendation, emails)
    @recommendation = recommendation
    @client = recommendation.client

    if recommendation.cv.attached?
      attachments[recommendation.cv.filename.to_s] = recommendation.cv.download
    end

    mail(
      to: Array(emails),
      cc: 'laurenz@geroldpartners.com',
      reply_to: 'laurenz@geroldpartners.com',
      subject: "Candidate recommendation — #{@recommendation.name}"
    )
  end
end
