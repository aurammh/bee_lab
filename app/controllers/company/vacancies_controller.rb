class Company::VacanciesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company_vacancy, only: %i[ show edit update destroy ]
  include CommonHelper
  # GET /company/vacancies or /company/vacancies.json
  def index
    @company_vacancies = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name')
    .joins(:m_industries,:m_occupations).where("company_id= ?", current_user.company.id)
    @company_vacancies = Kaminari.paginate_array(@company_vacancies).page(params[:page]).per(12)
  end

  # GET /company/vacancies/1 or /company/vacancies/1.json
  def show
    @company_vacancy_list = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name')
    .joins(:m_industries,:m_occupations).where(id: params[:id]).take

    @welfare_list =
    if @company_vacancy_list.welfare_list_data.present?
      welfare_list = @company_vacancy_list.welfare_list_data.select { |item| nil != item}
      welfare_data_index =  welfare_list.each_index.select { |i| welfare_list[i]== 1 }.map!{|element| element.is_a?(Integer) ? element + 1 : element}
      if welfare_data_index.any?
        MWelfareDetail.where("id IN (#{welfare_data_index.join(',')})").map { |wf| [wf.welfare_type]}.join(', ')
      end
    end

    #get favorite vacancy list by student
    unless current_user.user_type == 1
      favorite_vacancy = @company_vacancy_list.apply_favourite_transictions.where(std_job_favourite: true,student_id: current_user.student.id)
      @fav_vacancy = favorite_vacancy.present? ? true :false
    end
  end

  # GET /company/vacancies/new
  def new
    permission_url
    @company_vacancy = Company::Vacancy.new
    @company_postal_address = Company::Company.select("companies.postal_code,companies.postalcode_city,companies.m_region_id,companies.m_prefecture_id,companies.address").where(id: current_user.company.id).take
    @copy_postal_address_btn = true
  end

  # GET /company/vacancies/1/edit
  def edit
    @copy_postal_address_btn = false
  end

  # POST /company/vacancies or /company/vacancies.json
  def create
    @company_vacancy = Company::Vacancy.new(company_vacancy_params)
    @company_vacancy.company_id = current_user.company.id
    #convert json data type to array
    com_enhancement = getJsonKey(params[:company_vacancy][:company_enhancement])
    welfare_list = getJsonKey(params[:company_vacancy][:welfare_list_data])
    @company_vacancy.company_enhancement = com_enhancement
    @company_vacancy.welfare_list_data = welfare_list
    respond_to do |format|
      if @company_vacancy.save
        format.html { redirect_to @company_vacancy}
        format.json { render :show, status: :created, location: @company_vacancy }
      else
        @company_postal_address = Company::Company.select("companies.postal_code,companies.postalcode_city,companies.m_region_id,companies.m_prefecture_id,companies.address").where(id: current_user.company.id).take
        @copy_postal_address_btn = true
        format.html { render :new }
        format.json { render json: @company_vacancy.errors}
      end
    end
  end

  # PATCH/PUT /company/vacancies/1 or /company/vacancies/1.json
  def update
    #convert json data type to array
    com_enhancement = getJsonKey(params[:company_vacancy][:company_enhancement])
    welfare_list = getJsonKey(params[:company_vacancy][:welfare_list_data])
    @company_vacancy.company_enhancement = com_enhancement
    @company_vacancy.welfare_list_data = welfare_list
    respond_to do |format|
      if @company_vacancy.update(company_vacancy_params)
        format.html { redirect_to @company_vacancy }
        format.json { render :show, status: :ok, location: @company_vacancy }
      else
        format.html { render :edit }
        format.json { render json: @company_vacancy.errors}
      end
    end
  end

  # DELETE /company/vacancies/1 or /company/vacancies/1.json
  def destroy
    @company_vacancy.destroy
    respond_to do |format|
      format.html { redirect_to company_vacancies_url}
      format.json { head :no_content }
    end
  end

  private
  def permission_url
    if @permission_list.include?(2)
      redirect_to company_companies_path
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_company_vacancy
      @company_vacancy = Company::Vacancy.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_vacancy_params
      #params.fetch(:company_vacancy, {})
      params.require(:company_vacancy).permit(:company_id, :vacancy_code , :vacancy_title, :vacancy_description , :postal_code, :postalcode_city, :m_region_id, :region_name, :m_prefecture_id, :prefecture_name, :address, :display_address,
        :recruit_industry_type, :recruit_job_type, :required_applicants, :basic_salary, :model_salary, :promotion , :allowance, :bonus, :probation, :transportation_allowance, :dormitory, :insurance, :severance_pay, :other, :working_hours, :break_time, 
        :over_time, :holiday, :display_from, :display_to,:other_skill, :published_flg, :required_applicants_string, :hiring_flow_data => [], :company_enhancement => [], :welfare_list_data => [])
    end
end
