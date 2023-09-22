class Company::SearchController < ApplicationController
    before_action :authenticate_user!
    include CommonHelper
    include Student::AssessmentsHelper
    def index     
        params[:location_id] = []
        params[:locationDetail_id] = []
        params[:jobcategory_id] = []
        params[:gender] = []
        #[delete_flag search with false]
        delete_flag_query =  "delete_flg = false"
        @results = Company::Company.new.search_student([delete_flag_query],[])
        @results = Kaminari.paginate_array(@results).page(params[:page]).per(12)
        render "company/search/search_student"
    end    

    def student_search
        location_query = ""
        company_favourite_query = ""
        gender_query  = ""
  
        #[location search search]
        location_query = search_params[:m_region_id].blank? ? params[:m_region_id] = [] : "m_region_id = #{params[:m_region_id]}"

        #[location Detail search]        
        @locationDetails_pararms = params[:locationDetail_id].blank? ? [] : params[:locationDetail_id]
        location_detail_query = params[:locationDetail_id].blank? ? params[:locationDetail_id] = [] : "m_prefecture_id && ARRAY#{params[:locationDetail_id].map(&:to_i)}"

        #[job type search]
        job_category_query = params[:jobcategory_id].blank? ? params[:jobcategory_id] = [] : "desire_job_type_id && ARRAY#{params[:jobcategory_id].map(&:to_i)}"

        #[gender search]
        gender_query = params[:gender].blank? ? params[:gender] = [] : "gender = #{params[:gender]}"

        #[delete_flag search with false]
        delete_flag_query =  "delete_flg = false"
        
        @temp_results = Company::Company.new.search_student([location_query,gender_query,delete_flag_query],[job_category_query,location_detail_query])
        @results = @temp_results.reject { |i| i.birthday.nil? }
        favourite_company_current_student
        @results = Kaminari.paginate_array(@results).page(params[:page]).per(12)
        render "company/search/search_student"
    end

    def student_detail
        render "company/search/search_student_detail"
    end

    #  Call by ajax to location deatils by m_region_id
    def getLocationDetails
        locationDetailList = MPrefecture.where(m_region_id: params[:m_region_id]).map { |locationDetail| [locationDetail.prefecture_name, locationDetail.id] }
        render json: locationDetailList.to_json
    end


    def student_details
        @student_info = Student::Student.select('students.*,apply_favourite_transictions.company_id,apply_favourite_transictions.com_std_favourite').left_joins(:apply_favourite_transictions).find(params[:id])
        @student_assessment = Student::Assessment.find_by(student_id: params[:id])
        have_fav_student = ApplyFavouriteTransiction.find_by(student_id: @student_info.id, company_id: current_user.company.id)
        @fav_student = have_fav_student.nil? ? false : have_fav_student.com_std_favourite
        
        #call radar chart one function
        selfEevaluationChart_rank(@student_assessment)
        #call radar chart two function
        potentialDesireType(@student_assessment)
        #call third function
        behavioralTraitTypeChart_rank(@student_assessment)
        render "company/search/search_student_detail"

    end

    # favourite_student by ajax
    def favourite_student
        userObj = current_user.company.apply_favourite_transictions.find_by(student_id: params[:id])
        if userObj.nil?
            userObj = ApplyFavouriteTransiction.new
            userObj.student_id = params[:id]
            userObj.company_id = current_user.company.id
            userObj.com_std_favourite = true
            userObj.action_date = DateTime.current.to_date
        else
            userObj.toggle!(:com_std_favourite)
            userObj.update_attribute(:action_date, Date.today)
        end
        userObj.save
        render :json => { :status => "ok", :com_std_favourite => userObj.com_std_favourite }
    end
    

    private
    def search_params
        params.permit(:m_region_id, :desire_job_id, :puppy, :gender, industry: [], status: [], jobcategory_id: [], locationDetail_id: [])
    end

    def favourite_company_current_student
        @student_favourite_arr = []
        student_favourite = current_user.company.apply_favourite_transictions.where(com_std_favourite: true)
        @student_favourite_arr = student_favourite.map{|data| data.student_id} unless @student_favourite.present?
    end
end