require "test_helper"

class Communication::CommunicationDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @communication_communication_detail = communication_communication_details(:one)
  end

  test "should get index" do
    get communication_communication_details_url
    assert_response :success
  end

  test "should get new" do
    get new_communication_communication_detail_url
    assert_response :success
  end

  test "should create communication_communication_detail" do
    assert_difference('Communication::CommunicationDetail.count') do
      post communication_communication_details_url, params: { communication_communication_detail: {  } }
    end

    assert_redirected_to communication_communication_detail_url(Communication::CommunicationDetail.last)
  end

  test "should show communication_communication_detail" do
    get communication_communication_detail_url(@communication_communication_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_communication_communication_detail_url(@communication_communication_detail)
    assert_response :success
  end

  test "should update communication_communication_detail" do
    patch communication_communication_detail_url(@communication_communication_detail), params: { communication_communication_detail: {  } }
    assert_redirected_to communication_communication_detail_url(@communication_communication_detail)
  end

  test "should destroy communication_communication_detail" do
    assert_difference('Communication::CommunicationDetail.count', -1) do
      delete communication_communication_detail_url(@communication_communication_detail)
    end

    assert_redirected_to communication_communication_details_url
  end
end
