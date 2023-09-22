require "test_helper"

class Student::AssessmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student_assessment = student_assessments(:one)
  end

  test "should get index" do
    get student_assessments_url
    assert_response :success
  end

  test "should get new" do
    get new_student_assessment_url
    assert_response :success
  end

  test "should create student_assessment" do
    assert_difference('Student::Assessment.count') do
      post student_assessments_url, params: { student_assessment: {  } }
    end

    assert_redirected_to student_assessment_url(Student::Assessment.last)
  end

  test "should show student_assessment" do
    get student_assessment_url(@student_assessment)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_assessment_url(@student_assessment)
    assert_response :success
  end

  test "should update student_assessment" do
    patch student_assessment_url(@student_assessment), params: { student_assessment: {  } }
    assert_redirected_to student_assessment_url(@student_assessment)
  end

  test "should destroy student_assessment" do
    assert_difference('Student::Assessment.count', -1) do
      delete student_assessment_url(@student_assessment)
    end

    assert_redirected_to student_assessments_url
  end
end
