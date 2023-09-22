require "test_helper"

class Communication::CommunicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @communication_communication = communication_communications(:one)
  end

  test "should get index" do
    get communication_communications_url
    assert_response :success
  end

  test "should get new" do
    get new_communication_communication_url
    assert_response :success
  end

  test "should create communication_communication" do
    assert_difference('Communication::Communication.count') do
      post communication_communications_url, params: { communication_communication: {  } }
    end

    assert_redirected_to communication_communication_url(Communication::Communication.last)
  end

  test "should show communication_communication" do
    get communication_communication_url(@communication_communication)
    assert_response :success
  end

  test "should get edit" do
    get edit_communication_communication_url(@communication_communication)
    assert_response :success
  end

  test "should update communication_communication" do
    patch communication_communication_url(@communication_communication), params: { communication_communication: {  } }
    assert_redirected_to communication_communication_url(@communication_communication)
  end

  test "should destroy communication_communication" do
    assert_difference('Communication::Communication.count', -1) do
      delete communication_communication_url(@communication_communication)
    end

    assert_redirected_to communication_communications_url
  end
end
