require "application_system_test_case"

class Company::AssessmentsTest < ApplicationSystemTestCase
  setup do
    @company_assessment = company_assessments(:one)
  end

  test "visiting the index" do
    visit company_assessments_url
    assert_selector "h1", text: "Company/Assessments"
  end

  test "creating a Assessment" do
    visit company_assessments_url
    click_on "New Company/Assessment"

    click_on "Create Assessment"

    assert_text "Assessment was successfully created"
    click_on "Back"
  end

  test "updating a Assessment" do
    visit company_assessments_url
    click_on "Edit", match: :first

    click_on "Update Assessment"

    assert_text "Assessment was successfully updated"
    click_on "Back"
  end

  test "destroying a Assessment" do
    visit company_assessments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Assessment was successfully destroyed"
  end
end
