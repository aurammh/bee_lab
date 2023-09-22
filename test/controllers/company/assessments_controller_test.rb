require "test_helper"

class Company::AssessmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_assessment = company_assessments(:one)
  end

  test "should get index" do
    get company_assessments_url
    assert_response :success
  end

  test "should get new" do
    get new_company_assessment_url
    assert_response :success
  end

  test "should create company_assessment" do
    assert_difference('Company::Assessment.count') do
      post company_assessments_url, params: { company_assessment: {  } }
    end

    assert_redirected_to company_assessment_url(Company::Assessment.last)
  end

  test "should show company_assessment" do
    get company_assessment_url(@company_assessment)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_assessment_url(@company_assessment)
    assert_response :success
  end

  test "should update company_assessment" do
    patch company_assessment_url(@company_assessment), params: { company_assessment: {  } }
    assert_redirected_to company_assessment_url(@company_assessment)
  end

  test "should destroy company_assessment" do
    assert_difference('Company::Assessment.count', -1) do
      delete company_assessment_url(@company_assessment)
    end

    assert_redirected_to company_assessments_url
  end
end
