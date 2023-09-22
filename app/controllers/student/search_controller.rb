class Student::SearchController < ApplicationController
    before_action :authenticate_user!
    include CommonHelper
    def company_search
        industry_query = params[:industry_id].blank? ? params[:industry_id] = [] : "companies.m_industry_id = '#{params[:industry_id]}'"
        @companies = Student::Student.company_search_by_association([industry_query])
        favourite_company_current_student
        @companies = Kaminari.paginate_array(@companies).page(params[:page]).per(12)
        render "student/search/search_company"
    end

    def company_detail
        @company_details = Company::Company.select('companies.*,m_industries.industry_name').joins(:m_industries).find(params[:id])
        @company_assessment = Company::Assessment.find_by(company_id: params[:id])
        favo_company = @company_details.apply_favourite_transictions.where(std_com_favourite: true,student_id: current_user.student.id)
        @fav_company = favo_company.present? ? true :false
        render "student/search/search_company_detail"
    end


    def favourite_company
        @applied_favourite = ApplyFavouriteTransiction.find_by(student_id: current_user.student.id, company_id: params[:id])
        if @applied_favourite.nil?
            @applied_favourite = ApplyFavouriteTransiction.new(:student_id=>current_user.student.id, :company_id=>params[:id],:job_id=>nil,
                :std_com_favourite=> true,:std_job_favourite=> false,:com_std_favourite=> false,:std_job_apply=> false,:action_date=> Date.today)
        else
            @applied_favourite.toggle!(:std_com_favourite)
            @applied_favourite.update_attribute(:action_date, Date.today)
        end
        @applied_favourite.save
        render :json => {:status => 'ok', :favourite_flag => @applied_favourite.std_com_favourite}
    end

    #Part of Vacancy Search
    def vacancy_search
        industry_query = params[:industry_id].blank? ? params[:industry_id] = [] : "recruit_industry_type = '#{params[:industry_id]}'"
        job_type_query = params[:job_type_id].blank? ? params[:job_type_id] = [] : "recruit_job_type = '#{params[:job_type_id]}'"
        promotion_query = params[:promotion].nil? ? params[:promotion] = [] : "promotion = '#{params[:promotion]}'"
        overtime_query = params[:overtime].nil? ? params[:overtime] = [] : "over_time = '#{params[:overtime]}'"
        @vacancies = Student::Student.vacancy_search_by_association([industry_query,job_type_query,promotion_query,overtime_query])
        favourite_vacancy_current_student
        @vacancies = Kaminari.paginate_array(@vacancies).page(params[:page]).per(12)
        render "student/search/search_vacancy"
    end

    def favourite_vacancy
        @applied_favourite_vacancy = ApplyFavouriteTransiction.find_by(student_id: current_user.student.id, job_id: params[:id])
        if @applied_favourite_vacancy.nil?
            @applied_favourite_vacancy = ApplyFavouriteTransiction.new(:student_id=>current_user.student.id, :company_id=>nil,:job_id=>params[:id],
                :std_com_favourite=> false,:std_job_favourite=> true,:com_std_favourite=> false,:std_job_apply=> false,:action_date=> Date.today)
        else
            @applied_favourite_vacancy.toggle!(:std_job_favourite)
            @applied_favourite_vacancy.update_attribute(:action_date, Date.today)
        end
        @applied_favourite_vacancy.save
        render :json => {:status => 'ok', :favourite_flag => @applied_favourite_vacancy.std_job_favourite}
    end

    def search_event
        event_category_data = params[:category].blank? ? params[:category] = [] : "category && ARRAY#{params[:category].map(&:to_i)}"
        @events = Student::Student.event_search_by_association([event_category_data])
        favourite_event_current_student
        join_event_current_student
        @events = Kaminari.paginate_array(@events).page(params[:page]).per(12)
        render "student/search/search_event"
    end

    def search_event_detail
        @event_details = Company::Event.select('company_events.*').find(params[:id])
        favo_event = @event_details.apply_favourite_transictions.where(event_favourite: true,student_id: current_user.student.id)
        j_event = @event_details.apply_favourite_transictions.where(event_join: true,student_id: current_user.student.id)
        @fav_event = favo_event.present? ? true : false
        @join_event = j_event.present? ? true : false
        render "student/search/search_event_detail"
    end

    def favourite_event
        @applied_favourite_event = ApplyFavouriteTransiction.find_by(student_id: current_user.student.id, event_id: params[:id])
        if @applied_favourite_event.nil?
            @applied_favourite_event = ApplyFavouriteTransiction.new(:student_id=>current_user.student.id, :company_id=>nil,:job_id=>nil,
                :event_id=>params[:id],:std_com_favourite=> false,:std_job_favourite=> false,:com_std_favourite=> false,:std_job_apply=> false,
                :event_favourite=>true,:event_join=>false,:action_date=> Date.today)
        else
            @applied_favourite_event.toggle!(:event_favourite)
            @applied_favourite_event.event_join = @applied_favourite_event.event_join
            @applied_favourite_event.update_attribute(:action_date, Date.today)
        end
        @applied_favourite_event.save
        render :json => {:status => 'ok', :favourite_flag => @applied_favourite_event.event_favourite}
    end

    def join_event
        @applied_join_event = ApplyFavouriteTransiction.find_by(student_id: current_user.student.id, event_id: params[:id])
        if @applied_join_event.nil?
            @applied_join_event = ApplyFavouriteTransiction.new(:student_id=>current_user.student.id, :company_id=>nil,:job_id=>nil,
                :event_id=>params[:id],:std_com_favourite=> false,:std_job_favourite=> false,:com_std_favourite=> false,:std_job_apply=> false,
                :event_favourite=>false,:event_join=>true,:action_date=> Date.today)
        else
            @applied_join_event.toggle!(:event_join)
            @applied_join_event.event_favourite = @applied_join_event.event_favourite
            @applied_join_event.update_attribute(:action_date, Date.today)
        end
        @applied_join_event.save
        render :json => {:status => 'ok', :join_flag => @applied_join_event.event_join}
    end

    private
    def favourite_company_current_student
        @student_favourite_arr = []
        student_favourite = current_user.student.apply_favourite_transictions.where(std_com_favourite: true)
        @student_favourite_arr = student_favourite.map{|data| data.company_id} unless @student_favourite.present?
    end

    def favourite_vacancy_current_student
        @vacancy_favourite_arr = []
        vacancy_favourite = current_user.student.apply_favourite_transictions.where(std_job_favourite: true)
        @vacancy_favourite_arr = vacancy_favourite.map{|data| data.job_id} unless @vacancy_favourite.present?
    end

    def favourite_event_current_student
        @event_favourite_arr = []
        event_favourite = current_user.student.apply_favourite_transictions.where(event_favourite: true)
        @event_favourite_arr = event_favourite.map{|data| data.event_id} unless @event_favourite.present?
    end

    def join_event_current_student
        @join_event_arr = []
        join_event = current_user.student.apply_favourite_transictions.where(event_join: true)
        @join_event_arr = join_event.map{|data| data.event_id} unless @join_event.present?
    end
end