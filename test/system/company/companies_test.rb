require "application_system_test_case"

class Company::CompaniesTest < ApplicationSystemTestCase
  setup do
    @company_company = company_companies(:one)
  end

  test "visiting the index" do
    visit company_companies_url
    assert_selector "h1", text: "Company/Companies"
  end

  test "creating a Company" do
    visit company_companies_url
    click_on "New Company/Company"

    click_on "Create Company"

    assert_text "Company was successfully created"
    click_on "Back"
  end

  test "updating a Company" do
    visit company_companies_url
    click_on "Edit", match: :first

    click_on "Update Company"

    assert_text "Company was successfully updated"
    click_on "Back"
  end

  test "destroying a Company" do
    visit company_companies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Company was successfully destroyed"
  end
end
