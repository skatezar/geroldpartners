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
end
