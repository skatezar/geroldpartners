require "test_helper"

class MandatesControllerTest < ActionDispatch::IntegrationTest
  test "should get apply" do
    get mandates_apply_url
    assert_response :success
  end
end
