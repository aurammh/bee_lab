require "test_helper"

class Company::CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_company = company_companies(:one)
  end

  test "should get index" do
    get company_companies_url
    assert_response :success
  end

  test "should get new" do
    get new_company_company_url
    assert_response :success
  end

  test "should create company_company" do
    assert_difference('Company::Company.count') do
      post company_companies_url, params: { company_company: {  } }
    end

    assert_redirected_to company_company_url(Company::Company.last)
  end

  test "should show company_company" do
    get company_company_url(@company_company)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_company_url(@company_company)
    assert_response :success
  end

  test "should update company_company" do
    patch company_company_url(@company_company), params: { company_company: {  } }
    assert_redirected_to company_company_url(@company_company)
  end

  test "should destroy company_company" do
    assert_difference('Company::Company.count', -1) do
      delete company_company_url(@company_company)
    end

    assert_redirected_to company_companies_url
  end
end
