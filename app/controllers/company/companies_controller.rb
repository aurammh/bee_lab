class Company::CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_company, only: %i[ show edit update index destroy ]
  include CommonHelper
  # GET /company/companies or /company/companies.json
  def index

    #for dashboard favourite list
    @favourite_users_list = Company::Company.new.get_favourite_list(current_user.company.id).limit(4)
  
    #for show created vacancy list 
    @company_vacancies = Company::Company.new.get_vacancy_list(current_user.company.id).limit(4)

    # get event entry list
    @event_entry_list = Company::Company.new.get_event_entry_list(current_user.company.id).limit(4)
    @student_join_event = Company::Company.new.get_join_event_student_count(current_user.company.id).limit(4)

    #get conversation list
    @conversationList = (Communication::Communication.new.get_conversation_details_list(current_user.id) | Communication::Communication.new.get_conversation_list(current_user.id)).sort_by(&:created_at).reverse.take(4)
    #get conversation count 
    @conversationDetailListCount = Communication::CommunicationDetail.all.group('communication_id').count
    #to check read or not conversation
    new_communication_array
    
    get_hash_value(@student_join_event)
  end

  #show all favourite user/student list
  def favourite_student_index
    @favourite_users_list = Company::Company.new.get_favourite_list(current_user.company.id)
    @favourite_users_list = Kaminari.paginate_array(@favourite_users_list).page(params[:page]).per(12)
    render "company/companies/list/favourite_student_index"
  end

  #show student list who are joining event
  def join_event_student_list
    @join_event_list = Company::Company.new.get_joined_event_student_list(params[:id])
    @event_code = Company::Event.find(params[:id]).event_code
    @join_event_list = Kaminari.paginate_array(@join_event_list).page(params[:page]).per(12)
    render "company/companies/list/join_event_student_list"
  end

  # GET /company/companies/1 or /company/companies/1.json
  def show
  end

  # GET /company/companies/new
  def new
    @company_company = Company::Company.new
  end

  # GET /company/companies/1/edit
  def edit
    @genuine_password_flag = false || params[:genuine_password]
  end

  # POST /company/companies or /company/companies.json
  def create
    @company_company = Company::Company.new(company_company_params)
    respond_to do |format|
      if @company_company.save
        format.html { redirect_to @company_company}
        format.json { render :show, status: :created, location: @company_company }
      else
        format.html { render :new }
        format.json { render json: @company_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company/companies/1 or /company/companies/1.json
  def update    
    respond_to do |format|
      if @user_company.update(company_company_params)

        # To delete upload image
        if params[:company_company][:imageFlag] == "true"
          @user_company.image.purge
        end
        unless params[:company_company][:image_data].eql?"false"
          blob = convert_Base64_imgData(params[:company_company][:image_data])
          @user_company.image.attach(blob)
          params[:company_company][:image_data] = false
        end
        format.html { redirect_to @user_company}
        format.json { render :show, status: :ok, location: @user_company }
      else
        format.html { render :edit }
        format.json { render json: @user_company.errors, status: :unprocessable_entity }
             
      end
    end
  end

  # DELETE /company/companies/1 or /company/companies/1.json
  def destroy
    @company_company.destroy
    respond_to do |format|
      format.html { redirect_to company_companies_url}
      format.json { head :no_content }
    end
  end

  #set mail setting
  def mail_settings
    @com_info = current_user.company
    @com_info.update_attribute(:mail_setting, params[:mail_setting].to_i)
    @com_info.save
    render :json => {:status => 'ok', :mail_setting => @com_info.mail_setting}
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_company
      @user_company = current_user.company
    end
    
    # Only allow a list of trusted parameters through.
    def company_company_params
      params.require(:company_company).permit(:email, :company_name, :company_name_kana, :postal_code, :user_name,
        :address, :display_address, :phone_no, :m_industry_id,:company_info, :image, :website_url, :postalcode_city, :m_region_id, :region_name, :m_prefecture_id, :prefecture_name ,:company_established, :job_info, :contact, :capital_amount, :employee_count, :sales_amount, :related_company, :representative, :main_bank, :history, :transportation_facilities,:avg_service_year, :avg_overtime_per_month, :avg_paid_leaves,:number_eligible_childcare_leaves_male,:taken_childcare_leaves_male,:childcare_leave_acquisition_rate_male,:number_eligible_childcare_leaves_female,:taken_childcare_leaves_female,:rate_taken_childcare_leaves_female,:basic_idea,:percentage_female_ration,:percentage_training,:mentor_system,:career_consulting_system,:in_house_certification_system,:avg_service_year_string,:capital_amount_string,:sales_amount_string)
    end
end
