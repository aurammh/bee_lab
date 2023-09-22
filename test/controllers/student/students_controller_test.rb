require "test_helper"

class Student::StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student_student = student_students(:one)
  end

  test "should get index" do
    get student_students_url
    assert_response :success
  end

  test "should get new" do
    get new_student_student_url
    assert_response :success
  end

  test "should create student_student" do
    assert_difference('Student::Student.count') do
      post student_students_url, params: { student_student: {  } }
    end

    assert_redirected_to student_student_url(Student::Student.last)
  end

  test "should show student_student" do
    get student_student_url(@student_student)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_student_url(@student_student)
    assert_response :success
  end

  test "should update student_student" do
    patch student_student_url(@student_student), params: { student_student: {  } }
    assert_redirected_to student_student_url(@student_student)
  end

  test "should destroy student_student" do
    assert_difference('Student::Student.count', -1) do
      delete student_student_url(@student_student)
    end

    assert_redirected_to student_students_url
  end
end
