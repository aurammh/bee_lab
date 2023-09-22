class Student::StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_student, only: %i[ show edit update index destroy ]
  include CommonHelper

  def prefecture_name
    prefecture_name_list
  end

  # GET /student/students or /student/students.json
  def index
    #compancy favourite list for dashboard
    @favourite_company_list = Student::Student.new.get_favourite_company_list(current_user.student.id).limit(4)

    #vacancy favourite list for dashboard
    @favourite_vacancy_list = Student::Student.new.get_favourite_vacancy_list(current_user.student.id).limit(4)

    #event posted list for dashboard
    @join_event_list = Student::Student.new.get_join_event_list(current_user.student.id).limit(4)

    #event favourite list for dashboard
    @favourite_event_list = Student::Student.new.get_favourite_event_list(current_user.student.id).limit(4)
    
    # get conversation lists
    @conversationList = (Communication::Communication.new.get_conversation_details_list(current_user.id) | Communication::Communication.new.get_conversation_list(current_user.id)).sort_by(&:created_at).reverse.take(4)
    #get conversation count 
    @conversationDetailListCount = Communication::CommunicationDetail.all.group('communication_id').count
    #to check read or not conversation
    new_communication_array
  end

  # view all favourite company list
  def favourite_company_index
    @all_favourite_company_list = Student::Student.new.get_favourite_company_list(current_user.student.id)
    @all_favourite_company_list = Kaminari.paginate_array(@all_favourite_company_list).page(params[:page]).per(12)
    render "student/students/list/favourite_company_index"
  end

  # view all favourite vacancy list
  def favourite_vacancy_index
    @all_favourite_vacancy_list = Student::Student.new.get_favourite_vacancy_list(current_user.student.id)
    @all_favourite_vacancy_list = Kaminari.paginate_array(@all_favourite_vacancy_list).page(params[:page]).per(12)
    render "student/students/list/favourite_vacancy_index"
  end

  # view all published entry event list
  def join_event_index
    @all_join_event_list = Student::Student.new.get_join_event_list(current_user.student.id)
    @all_join_event_list = Kaminari.paginate_array(@all_join_event_list).page(params[:page]).per(12)
    render "student/students/list/join_event_index"
  end

  # view all favourite event list
  def favourite_event_index
    @all_favourite_event_list = Student::Student.new.get_favourite_event_list(current_user.student.id)
    @all_favourite_event_list = Kaminari.paginate_array(@all_favourite_event_list).page(params[:page]).per(12)
    render "student/students/list/favourite_event_index"
  end

  # GET /student/students/1 or /student/students/1.json
  def show
  end

  # GET /student/students/new
  def new
    @student_student = Student::Student.new
  end

  # GET /student/students/1/edit
  def edit
    @genuine_password_flag = false || params[:genuine_password]
  end

  # POST /student/students or /student/students.json
  def create
    @student_student = Student::Student.new(student_student_params)
    #convert json data type to array
    outside_activity = getJsonKey(params[:student_student][:outside_school_activity])
    @student_student.outside_school_activity = outside_activity
    respond_to do |format|
      if @student_student.save
        format.html { redirect_to @student_student }
        format.json { render :show, status: :created, location: @student_student }
      else
        format.html { render :new }
        format.json { render json: @student_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student/students/1 or /student/students/1.json
  def update
    #convert json data type to array
    outside_activity = getJsonKey(params[:student_student][:outside_school_activity])
    @user_student.outside_school_activity = outside_activity
    respond_to do |format|
      #To delete upload image
        if (params[:student_student][:imageFlag] == "true")
          @user_student.image.purge
        end
      #To delete upload pdf file
        if (params[:student_student][:haveFileFlag] == "true")
          @user_student.attachment_for_pr.purge
        end
      if @user_student.update(student_student_params)
        unless params[:student_student][:image_data].eql?"false"
          blob = convert_Base64_imgData(params[:student_student][:image_data])
          @user_student.image.attach(blob)
          params[:student_student][:image_data] = false
        end
        format.html { redirect_to @user_student}
        format.json { render :show, status: :ok, location: @user_student }
      else
        format.html { render :edit }
        format.json { render json: @user_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student/students/1 or /student/students/1.json
  def destroy
    @student_student.destroy
    respond_to do |format|
      format.html { redirect_to student_students_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_student
      @student_student = Student::Student.find(params[:id])
    end

    def set_user_student
      @user_student = current_user.student
    end

    # Only allow a list of trusted parameters through.
    def student_student_params
      #params.fetch(:student_student, {})
      params.require(:student_student).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :gender, :image, :birthday, :nick_name, :email, :email_two, :address, :postal_code, :display_address, :phone_no, :postal_region_id, :region_name, :postal_prefecture_id, :prefecture_name, :postalcode_city, :school_type, :school_name, :department_name, :subject_system, :graduation_date, :m_region_id, :transfer, :club_name, :club_position, :club_detail_activity, :club_guide, :is_beelab_activity_participate, :beelab_college_achievements, :attachment_for_pr, :sns_blog_for_pr, :pando_info,:job_info, qualification_category_id: [], qualification_type_id: [], desire_job_type_id: [], desire_industry_type_id: [], m_prefecture_id: [], :outside_school_activity => [])
    end
end