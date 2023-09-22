class Admin::CompanyManage::VacanciesController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_admin_vacancy, only: %i[ vacancy_edit vacancy_update ]

    include CommonHelper
    layout 'layouts/template/admin'

      def vacancy_search
        vacancy_startDate = params[:vacancy_startDate].blank? ? nil : params[:vacancy_startDate]
        keyword = params[:company_name].blank? ? nil : params[:company_name].strip
        vacancy_endDate = params[:vacancy_endDate].blank? ? nil : params[:vacancy_endDate]
          if vacancy_startDate.blank? && !vacancy_endDate.blank?
            @results_vacancy = Company::Vacancy.admin_vacancy_search_by_only_end_date(vacancy_endDate, keyword)
          elsif(!vacancy_startDate.blank? && vacancy_endDate.blank?)
            @results_vacancy = Company::Vacancy.admin_vacancy_search_by_start_date(vacancy_startDate, keyword)
          elsif(!vacancy_startDate.blank? && !vacancy_endDate.blank?)
            @results_vacancy = Company::Vacancy.admin_vacancy_search_by_between_two_date(vacancy_startDate,vacancy_endDate, keyword)
          else
            @results_vacancy = Company::Vacancy.admin_vacancy_init_list(keyword) 
          end
        @results_vacancy = Kaminari.paginate_array(@results_vacancy).page(params[:page]).per(12)
      end
    
      def vacancy_details
        @company_vacancy_list = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name')
        .joins(:m_industries,:m_occupations).where(id: params[:vacancyid]).take
      end
    
      def vacancy_edit
      end
    
      def vacancy_update
        respond_to do |format|
          if @vacancy_edit.update(vacancy_params)
            format.html { redirect_to admin_company_manage_vacancy_details_path(vacancyid: @vacancy_edit.id) }
            format.json { render :show, status: :ok, location: @vacancy_edit }
          else
            format.html { render :vacancy_edit }
            format.json { render json: @vacancy_edit.errors}
          end
        end
      end
      
      def vacancy_delete
        admin_vacancy_obj = Company::Vacancy.find(params[:id])
        admin_vacancy_obj.update_columns(delete_flg: true)
        redirect_to admin_company_manage_vacancy_search_path
      end

      private

      def set_admin_vacancy
        @vacancy_edit = Company::Vacancy.find(params[:id])
      end
    
      def vacancy_params
        #params.fetch(:company_vacancy, {})
        params.require(:company_vacancy).permit(:company_id, :vacancy_code , :vacancy_title, :vacancy_description , :postal_code, :postalcode_city, :m_region_id, :region_name, :m_prefecture_id, :prefecture_name, :address, :display_address,
          :recruit_industry_type, :recruit_job_type, :required_applicants, :basic_salary, :model_salary, :promotion , :allowance, :bonus, :probation, :transportation_allowance, :dormitory, :insurance, :severance_pay, :other, :working_hours, :break_time, 
          :over_time, :holiday, :display_from, :display_to,:other_skill, :published_flg, :required_applicants_string, :hiring_flow_data => [], :company_enhancement => [], :welfare_list_data => [])
      end

end
