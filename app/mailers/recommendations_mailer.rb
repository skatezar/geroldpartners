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

  def availability_link(recommendation)
    @recommendation = recommendation
    @client = recommendation.client
    @availability_url = availability_url(@recommendation.availability_token)

    mail(
      to: @recommendation.email,
      cc: 'laurenz@geroldpartners.com',
      reply_to: 'laurenz@geroldpartners.com',
      subject: "Share your availability — #{@client.name}"
    )
  end

  def availability_submitted(recommendation)
    @recommendation = recommendation
    @client = recommendation.client
    @slots = recommendation.availability_slots_parsed
    @timezone = recommendation.availability_timezone.presence || @client.timezone.presence

    client_emails = @client.contact_emails.to_s.split(",").map(&:strip).reject(&:blank?)
    to_emails = client_emails.presence || ['laurenz@geroldpartners.com']

    mail(
      to: to_emails,
      cc: ['laurenz@geroldpartners.com', @recommendation.email].uniq,
      reply_to: 'laurenz@geroldpartners.com',
      subject: "#{@recommendation.name} — available interview slots"
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
