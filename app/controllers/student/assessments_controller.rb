class Student::AssessmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student_assessment, only: %i[ show index edit update destroy ]
  include Student::AssessmentsHelper
  include CommonHelper

  # GET /student/assessments or /student/assessments.json
  def index
    #For chart One
    selfEevaluationChart_rank(@student_assessment)
    #For chart Two
    potentialDesireType(@student_assessment)
    #For chart Three
    behavioralTraitTypeChart_rank(@student_assessment)
  end

  # GET /student/assessments/1 or /student/assessments/1.json
  def show
  end

  # GET /student/assessments/new
  def new
    @student_assessment = Student::Assessment.new
  end

  # GET /student/assessments/1/edit
  def edit
  end

  # POST /student/assessments or /student/assessments.json
  def create
    @student_assessment = Student::Assessment.new(student_assessment_params)
    @student_assessment.student_id = current_user.student.id
    #For chartOne and chartThree save and update
    selfEevaluation_n_behavioral_trait_type(@student_assessment)
    respond_to do |format|
      if @student_assessment.save
        format.html { redirect_to student_assessments_path }
      else
        format.html { redirect_to student_assessments_path }
      end
    end
  end

  # PATCH/PUT /student/assessments/1 or /student/assessments/1.json
  def update
   #For chartOne and chartThree save and update
    selfEevaluation_n_behavioral_trait_type(@student_assessment)
    respond_to do |format|
      if @student_assessment.update(student_assessment_params)
      format.html { redirect_to student_assessments_path }
      else
        format.html { redirect_to student_assessments_path }
      end
    end
  end

  # DELETE /student/assessments/1 or /student/assessments/1.json
  def destroy
    @student_assessment.destroy
    respond_to do |format|
      format.html { redirect_to student_assessments_url }
      format.json { head :no_content }
    end
  end

  def student_smart_brain_diagnosis
    set_student_assessment
    render "student/assessments/brain/brain"
  end

  def student_potential_desire_type_diagnosis
    set_student_assessment
    render "student/assessments/potential/potential"
  end

  def student_behavioral_trait_type
    set_student_assessment
    render "student/assessments/behavioral/behavioral"
  end

  private

    def selfEevaluation_n_behavioral_trait_type(student_assessment)
      # For ChartOne save and update 
      if !params[:student_assessment][:logical_and_rational].blank? || !params[:student_assessment]  [:solid_and_planned].blank? || !params[:student_assessment]  [:sensory_and_friendly].blank? || !params[:student_assessment]  [:adventurous_and_original].blank? 
        student_assessment.logical_and_rational =  getJsonKey (params[:student_assessment][:logical_and_rational])
        student_assessment.solid_and_planned =  getJsonKey (params[:student_assessment][:solid_and_planned])
        student_assessment.sensory_and_friendly =  getJsonKey (params[:student_assessment][:sensory_and_friendly])
        student_assessment.adventurous_and_original =  getJsonKey (params[:student_assessment][:adventurous_and_original])
        student_assessment.brain_action_date = Date.today
      end

      # For ChartTwo save and update
      if !params[:student_assessment][:love_and_desire_to_belong].blank?
        student_assessment.love_and_desire_to_belong =  getJsonKey (params[:student_assessment][:love_and_desire_to_belong])
        student_assessment.desire_for_power_and_value =  getJsonKey (params[:student_assessment][:desire_for_power_and_value])
        student_assessment.desire_for_freedom =  getJsonKey (params[:student_assessment][:desire_for_freedom])
        student_assessment.desire_for_fun =  getJsonKey (params[:student_assessment][:desire_for_fun])
        student_assessment.desire_for_survival =  getJsonKey (params[:student_assessment][:desire_for_survival])
        student_assessment.potential_action_date = Date.today 
      end

      # For ChartThree save and update
      if !params[:student_assessment][:self_expression].blank? || !params[:student_assessment][:self_assertion].blank? || !params[:student_assessment][:self_flexibility].blank?
        student_assessment.self_expression =  getJsonKey (params[:student_assessment][:self_expression])
        student_assessment.self_assertion =  getJsonKey (params[:student_assessment][:self_assertion])
        student_assessment.self_flexibility =  getJsonKey (params[:student_assessment][:self_flexibility])
        student_assessment.behavioral_action_date = Date.today 
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_student_assessment
      @student_assessment = current_user.student.assessment
      @student_assessment = Student::Assessment.new unless @student_assessment.present?
    end

    # Only allow a list of trusted parameters through.
    def student_assessment_params
      params.require(:student_assessment).permit(:first_priority_language, :second_priority_language, :third_priority_language,:english_qualification, :toefl_test, :toeic_test, :appeal_point_title_1, :appeal_point_article_1, :appeal_point_title_2, :appeal_point_article_2, :appeal_point_title_3, :appeal_point_article_3, :logical_and_rational => [], :solid_and_planned => [],:sensory_and_friendly => [],:adventurous_and_original => [], :love_and_desire_to_belong => [], :desire_for_power_and_value => [], :desire_for_freedom => [], :desire_for_fun => [], :desire_for_survival => [], :self_expression => [],:self_assertion => [],:self_flexibility => [])
    end
end
