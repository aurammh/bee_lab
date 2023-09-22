require "application_system_test_case"

class Communication::CommunicationsTest < ApplicationSystemTestCase
  setup do
    @communication_communication = communication_communications(:one)
  end

  test "visiting the index" do
    visit communication_communications_url
    assert_selector "h1", text: "Communication/Communications"
  end

  test "creating a Communication" do
    visit communication_communications_url
    click_on "New Communication/Communication"

    click_on "Create Communication"

    assert_text "Communication was successfully created"
    click_on "Back"
  end

  test "updating a Communication" do
    visit communication_communications_url
    click_on "Edit", match: :first

    click_on "Update Communication"

    assert_text "Communication was successfully updated"
    click_on "Back"
  end

  test "destroying a Communication" do
    visit communication_communications_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Communication was successfully destroyed"
  end
end
