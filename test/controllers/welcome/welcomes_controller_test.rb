require "test_helper"

class Welcome::WelcomesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get welcome_welcomes_index_url
    assert_response :success
  end
end
