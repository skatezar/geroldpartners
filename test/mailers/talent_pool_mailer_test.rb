require "test_helper"

class TalentPoolMailerTest < ActionMailer::TestCase
  test "new_application" do
    mail = TalentPoolMailer.new_application
    assert_equal "New application", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
