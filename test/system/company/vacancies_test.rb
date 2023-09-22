require "application_system_test_case"

class Company::VacanciesTest < ApplicationSystemTestCase
  setup do
    @company_vacancy = company_vacancies(:one)
  end

  test "visiting the index" do
    visit company_vacancies_url
    assert_selector "h1", text: "Company/Vacancies"
  end

  test "creating a Vacancy" do
    visit company_vacancies_url
    click_on "New Company/Vacancy"

    click_on "Create Vacancy"

    assert_text "Vacancy was successfully created"
    click_on "Back"
  end

  test "updating a Vacancy" do
    visit company_vacancies_url
    click_on "Edit", match: :first

    click_on "Update Vacancy"

    assert_text "Vacancy was successfully updated"
    click_on "Back"
  end

  test "destroying a Vacancy" do
    visit company_vacancies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vacancy was successfully destroyed"
  end
end
