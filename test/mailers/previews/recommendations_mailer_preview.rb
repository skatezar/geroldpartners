# Preview all emails at http://localhost:3000/rails/mailers/recommendations_mailer
class RecommendationsMailerPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/recommendations_mailer/interview_request
  def interview_request
    client = Client.new(name: "Fund ABC", slug: "fund-abc")
    rec = Recommendation.new(
      name: "Jane Doe",
      email: "jane.doe@example.com",
      client: client
    )
    RecommendationsMailer.interview_request(rec)
  end
end
