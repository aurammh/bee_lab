class Admin::CompanyManage::CompanyController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_company, only: %i[ company_edit company_update ]

  include CommonHelper
  layout 'layouts/template/admin'

  def company_search
    startDate = params[:startDate].blank? ? nil : params[:startDate]
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    endDate = params[:endDate].blank? ? nil : params[:endDate]
    @vacancy_status = Company::Vacancy.select(:company_id).distinct.map{|data| data.company_id}
    @event_status = Company::Event.select(:company_id).distinct.map{|data| data.company_id}
    if startDate.blank? && !endDate.blank?
      @result_list = Company::Company.admin_search_by_only_end_date(endDate, keyword)  
    elsif(!startDate.blank? && endDate.blank?)
      @result_list = Company::Company.admin_search_by_only_start_date(startDate, keyword)
    elsif(!startDate.blank? && !endDate.blank?)
      @result_list = Company::Company.admin_search_by_between_two_date(startDate, endDate, keyword) 
    else
      @result_list = Company::Company.admin_company_all_init_list(keyword)
    end 
    @results = Kaminari.paginate_array(@result_list).page(params[:page]).per(12)

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: t('search.excel_file_name'), template: 'admin/excel_template/company_excel_export'}
    end
  end

  def company_details
    @company_details = Company::Company.select('companies.*,m_industries.industry_name').left_outer_joins(:m_industries).find(params[:company_id])
    @company_assessment = Company::Assessment.find_by(company_id: params[:company_id])
  end
  

  def company_edit
  end

  def company_update    
    respond_to do |format|
      if @user_company.update(company_params)
        # To delete upload image
        if params[:company_company][:imageFlag] == "true"
          @user_company.image.purge
        end
        unless params[:company_company][:image_data].eql?"false"
          blob = convert_Base64_imgData(params[:company_company][:image_data])
          @user_company.image.attach(blob)
          params[:company_company][:image_data] = false
        end
        format.html { redirect_to admin_company_manage_company_details_path(company_id: @user_company.id)}
        format.json { render :show, status: :ok, location: @user_company }
      else
        format.html { render :company_edit }
        format.json { render json: @user_company.errors, status: :unprocessable_entity }    
      end
    end
  end

  def company_delete
    admin_com_obj = Company::Company.find(params[:id])
    admin_com_obj.update_columns(delete_flg: true)
    admin_com_obj.events.update_all(delete_flg: true)
    admin_com_obj.company_vacancies.update_all(delete_flg: true)
    admin_com_obj.user.update_columns(delete_flg: true, email: admin_com_obj.user.email + "_" + admin_com_obj.user.id.to_s, user_name: admin_com_obj.user.user_name + "_" + admin_com_obj.user.id.to_s)
    if params[:status] == "1"
      redirect_to admin_company_manage_company_search_path      	 
    else
      redirect_to admin_admin_company_setting_path
    end
  end


  def admin_company_setting
    name = params[:company_name].blank? ? nil : params[:company_name].strip
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    @permission_type = Admin::MPermissionType.where(use_company: true)
    @permissions = Admin::Permission.where(user_type: 1)
    if name.nil?  && keyword.nil? 
      @results =User.admin_company_setting_all()
    else
      @results = User.admin_company_search_setting(name, keyword)
    end  
    @results = Kaminari.paginate_array(@results).page(params[:page]).per(12)
  end

  def favourite_company
    @favourite_company_list = Company::Company.new.show_top_3_fav_company()
  end

  private
  def set_admin_company
    @user_company = Company::Company.find(params[:id])
    @user = @user_company.user
  end

  def company_params
    params.require(:company_company).permit(:email, :company_name, :company_name_kana, :postal_code, :user_name,
      :address, :display_address, :phone_no, :m_industry_id,:company_info, :image, :website_url, :postalcode_city, :m_region_id, :region_name, :m_prefecture_id, :prefecture_name ,:company_established, :job_info, :contact, :capital_amount, :employee_count, :sales_amount, :related_company, :representative, :main_bank, :history, :transportation_facilities,:avg_service_year, :avg_overtime_per_month, :avg_paid_leaves,:number_eligible_childcare_leaves_male,:taken_childcare_leaves_male,:childcare_leave_acquisition_rate_male,:number_eligible_childcare_leaves_female,:taken_childcare_leaves_female,:rate_taken_childcare_leaves_female,:basic_idea,:percentage_female_ration,:percentage_training,:mentor_system,:career_consulting_system,:in_house_certification_system,:avg_service_year_string,:capital_amount_string,:sales_amount_string)
  end
end