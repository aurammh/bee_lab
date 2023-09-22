require "application_system_test_case"

class Communication::CommunicationDetailsTest < ApplicationSystemTestCase
  setup do
    @communication_communication_detail = communication_communication_details(:one)
  end

  test "visiting the index" do
    visit communication_communication_details_url
    assert_selector "h1", text: "Communication/Communication Details"
  end

  test "creating a Communication detail" do
    visit communication_communication_details_url
    click_on "New Communication/Communication Detail"

    click_on "Create Communication detail"

    assert_text "Communication detail was successfully created"
    click_on "Back"
  end

  test "updating a Communication detail" do
    visit communication_communication_details_url
    click_on "Edit", match: :first

    click_on "Update Communication detail"

    assert_text "Communication detail was successfully updated"
    click_on "Back"
  end

  test "destroying a Communication detail" do
    visit communication_communication_details_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Communication detail was successfully destroyed"
  end
end
