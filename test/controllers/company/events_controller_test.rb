require "test_helper"

class Company::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_event = company_events(:one)
  end

  test "should get index" do
    get company_events_url
    assert_response :success
  end

  test "should get new" do
    get new_company_event_url
    assert_response :success
  end

  test "should create company_event" do
    assert_difference('Company::Event.count') do
      post company_events_url, params: { company_event: {  } }
    end

    assert_redirected_to company_event_url(Company::Event.last)
  end

  test "should show company_event" do
    get company_event_url(@company_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_event_url(@company_event)
    assert_response :success
  end

  test "should update company_event" do
    patch company_event_url(@company_event), params: { company_event: {  } }
    assert_redirected_to company_event_url(@company_event)
  end

  test "should destroy company_event" do
    assert_difference('Company::Event.count', -1) do
      delete company_event_url(@company_event)
    end

    assert_redirected_to company_events_url
  end
end
