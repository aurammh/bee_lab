class Company::AssessmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company_assessment, only: %i[ show edit update index destroy ]

  # GET /company/assessments or /company/assessments.json
  def index
  end

  # GET /company/assessments/1 or /company/assessments/1.json
  def show
  end

  # GET /company/assessments/new
  def new
    @company_assessment = Company::Assessment.new
  end

  # GET /company/assessments/1/edit
  def edit
  end

  # POST /company/assessments or /company/assessments.json
  def create
    @company_assessment = Company::Assessment.new(company_assessment_params)
    @company_assessment.company_id = current_user.company.id

    #convert json data to array
    seek_student_thinking_val = getJsonKey(params[:company_assessment][:seek_student_thinking_type])
    com_priority_item_val = getJsonKey(params[:company_assessment][:com_priority_item_type])
    @company_assessment.seek_student_thinking_type = seek_student_thinking_val
    @company_assessment.com_priority_item_type = com_priority_item_val 

    respond_to do |format|
      if @company_assessment.save
        format.html { redirect_to company_assessments_path}
      else
        format.html { redirect_to company_assessments_path, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company/assessments/1 or /company/assessments/1.json
  def update
    #convert json data to array
    seek_student_thinking_val = getJsonKey(params[:company_assessment][:seek_student_thinking_type])
    com_priority_item_val = getJsonKey(params[:company_assessment][:com_priority_item_type])
    @company_assessment.seek_student_thinking_type = seek_student_thinking_val
    @company_assessment.com_priority_item_type = com_priority_item_val 

    respond_to do |format|
      if @company_assessment.update(company_assessment_params)
        format.html { redirect_to company_assessments_path}
      else
        format.html { redirect_to company_assessments_path, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company/assessments/1 or /company/assessments/1.json
  def destroy
    @company_assessment.destroy
    respond_to do |format|
      format.html { redirect_to company_assessments_url}
      format.json { head :no_content }
    end
  end

  #get value from json object
  def getJsonKey (hashArray)
    keyVal = []   
    hashArray.each {|k, v| keyVal << v }
    keyVal
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_assessment
      @company_assessment =  current_user.company.assessment
      @company_assessment = Company::Assessment.new unless @company_assessment.present?
    end

    # Only allow a list of trusted parameters through.
    def company_assessment_params
      params.require(:company_assessment).permit(:com_priority_item_type => [],:seek_student_thinking_type => [])
    end
end
