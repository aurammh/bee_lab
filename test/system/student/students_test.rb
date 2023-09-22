require "application_system_test_case"

class Student::StudentsTest < ApplicationSystemTestCase
  setup do
    @student_student = student_students(:one)
  end

  test "visiting the index" do
    visit student_students_url
    assert_selector "h1", text: "Student/Students"
  end

  test "creating a Student" do
    visit student_students_url
    click_on "New Student/Student"

    click_on "Create Student"

    assert_text "Student was successfully created"
    click_on "Back"
  end

  test "updating a Student" do
    visit student_students_url
    click_on "Edit", match: :first

    click_on "Update Student"

    assert_text "Student was successfully updated"
    click_on "Back"
  end

  test "destroying a Student" do
    visit student_students_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Student was successfully destroyed"
  end
end
