require "test_helper"

class Company::VacanciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_vacancy = company_vacancies(:one)
  end

  test "should get index" do
    get company_vacancies_url
    assert_response :success
  end

  test "should get new" do
    get new_company_vacancy_url
    assert_response :success
  end

  test "should create company_vacancy" do
    assert_difference('Company::Vacancy.count') do
      post company_vacancies_url, params: { company_vacancy: {  } }
    end

    assert_redirected_to company_vacancy_url(Company::Vacancy.last)
  end

  test "should show company_vacancy" do
    get company_vacancy_url(@company_vacancy)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_vacancy_url(@company_vacancy)
    assert_response :success
  end

  test "should update company_vacancy" do
    patch company_vacancy_url(@company_vacancy), params: { company_vacancy: {  } }
    assert_redirected_to company_vacancy_url(@company_vacancy)
  end

  test "should destroy company_vacancy" do
    assert_difference('Company::Vacancy.count', -1) do
      delete company_vacancy_url(@company_vacancy)
    end

    assert_redirected_to company_vacancies_url
  end
end
