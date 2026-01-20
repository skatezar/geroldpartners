require "test_helper"

class TalentPoolApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get talent_pool_applications_create_url
    assert_response :success
  end
end
