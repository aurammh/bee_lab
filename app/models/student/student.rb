class Student::Student < ApplicationRecord
    belongs_to :user
    has_one :assessment, class_name: "Student::Assessment", foreign_key: "student_id", dependent: :destroy
    has_many :apply_favourite_transictions, class_name: "ApplyFavouriteTransiction", foreign_key: "student_id"
    belongs_to :m_regions, class_name: "MRegion", foreign_key: "postal_region_id",optional: true
    belongs_to :m_prefectures, class_name: "MPrefecture", foreign_key: "postal_prefecture_id",optional: true
    has_one_attached :image
    has_one_attached :attachment_for_pr
    before_save :upcase_fields
    self.table_name = "students"

    # 管理者関連
    scope :find_by_date, -> (startDate, endDate) { select('date(created_at) AS created_at,count(id) AS studentcount').where("date(created_at) >= '#{startDate}' and date(created_at) <= '#{endDate}' AND delete_flg = 'false'").group("date(created_at)") }
    scope :find_by_gender, -> { select('COALESCE( NULLIF(gender,NULL) ,2) AS gender_name,count(id) AS studentcount').where("date(created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND delete_flg = 'false'").group('gender_name').order('gender_name') }
    columnName = ["school_name","prefecture_name","club_name","(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthday))::text","(CASE WHEN birthday IS NULL THEN '本登録未完了' ELSE '本登録完了' END)","(CASE WHEN students.id in (Select distinct student_id from student_assessments) THEN '実施' ELSE '未実施' END)"]
    scope :admin_search_by_between_two_date, ->(date_type, startDate, endDate, keyword,gender_query,schooltype_query){
       name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword}%'))"
       keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')} #{name_search})"
       gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
       schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
       select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
       .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
        .where(       
           "to_date(students.#{date_type}::text,'YYYY-MM-DD') >= '#{startDate}' AND to_date(students.#{date_type}::text,'YYYY-MM-DD') <= '#{endDate}'AND students.delete_flg = 'false'" + keyword_search + gender_search + schooltype_search
       )
       .order("students.#{date_type} DESC")
       }
    
    scope :admin_search_by_only_start_date, ->(date_type, startDate, keyword,gender_query,schooltype_query){
    name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword}%'))"
    keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')} #{name_search})"
    gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
    schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
    select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
    .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
        .where(       
        "to_date(students.#{date_type}::text,'YYYY-MM-DD') >= '#{startDate}' AND students.delete_flg = 'false'" + keyword_search + gender_search + schooltype_search
    )
    .order("students.#{date_type} DESC")
    }

    scope :admin_search_by_only_end_date, ->(date_type, endDate, keyword,gender_query,schooltype_query){
       name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword}%'))"
       keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')} #{name_search})"
       gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
       schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
       select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
       .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
        .where(       
           "to_date(students.#{date_type}::text,'YYYY-MM-DD') <= '#{endDate}'AND students.delete_flg = 'false'" + keyword_search + gender_search + schooltype_search
       )
       .order("students.#{date_type} DESC")
       }

    scope :admin_all_init_list, ->(keyword,gender_query,schooltype_query) {
       name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword}%'))"
       keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')} #{name_search})"
       gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
       schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
       select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
       .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
        .where(       
           "students.delete_flg = 'false'" + keyword_search + gender_search + schooltype_search
       )
       .order("created_at DESC")
    }

    enum school_type: { university: 1, master_graduate: 2, doctor_graduate: 3, junior_college: 4, techanical_college: 5, national_college: 6, other_university: 7 }
    enum subject_system: { social: 1, science: 2, other_sub: 3 }
    enum outside_activity: { seminar: 1, inside_school_activity: 2, partime: 3, volenteer: 4, major_collage: 5, research:6, trip: 7, hobby: 8, start_up:9, aborad: 10, other_act: 11 }
    enum is_beelab_activity_participate: { beelab_activity_participate: true, not_beelab_activity_participate: false}
    enum gender: { male: 0, female: 1, other_gen: 2}
    enum number_employee: { bet_1_and_5: "1-5", bet_6_and_10: "6-10", bet_11_and_20: "11-20", 
        bet_21_and_50: "21-50", bet_51_and_100: "51-100", bet_101_and_200: "101-200",
        bet_201_and_500: "201-500", bet_501_and_1000: "501-1000", bet_1001_and_5000: "1001-5000", bet_5001_and_10000: "5001-10000", 
        bet_10001_and_20000: "10001-20000", bet_20000_and_more: "20000-20001" }                                     
    validates :last_name, length: { maximum: 100 }, presence: true
    validates :first_name, length: { maximum: 100 }, presence: true
    validates :first_name_kana, length: { maximum: 100 }, presence: true, on: :update, if: :first_name_kana_changed?
    validates :last_name_kana, length: { maximum: 100 }, presence: true, on: :update, if: :last_name_kana_changed?
    validates :birthday, presence: true, on: :update
    validates :nick_name, length: { maximum: 255 }, on: :update, if: :nick_name_changed?
    validates :email_two, :format => { :with => VALID_EMAIL_REGEX, message: "がフォーマット正しくありません。" }, :allow_blank => true, length: { maximum: 255 }, on: :update, if: :email_two_changed?
    validates :phone_no, presence: true, length: {within: 6..20 }, on: :update, if: :phone_no_changed?
    validates :address, length: { maximum: 255 }, presence: true, on: :update, if: :address_changed?
    validates :school_type, presence: true, :on => :update
    validates :school_name, length: { maximum: 60 }, presence: true, :on => :update
    validates :department_name, length: { maximum: 60 }, presence: true, :on => :update
    validates :subject_system, presence: true, :on => :update
    validates :graduation_date, presence: true, :on => :update
    validates :postal_code, presence: true, on: :update, if: :postal_code_changed?
    validates :region_name, presence: true, on: :update, if: :postal_region_id_changed?
    validates :prefecture_name, presence: true, on: :update, if: :postal_prefecture_id_changed?
    validates :postalcode_city, presence: true, on: :update, if: :postalcode_city_changed?
    validates :pando_info, :format => { :with => VALID_URL_REGEX, message: "がフォーマット正しくありません。" }, :allow_blank => true, length: { maximum: 255 }, on: :update, if: :pando_info_changed?
    attr_accessor :email, :prefecture_name, :region_name

    #Uppercase for last name and first name
    def upcase_fields
        self.last_name.upcase!
        self.first_name.upcase!
        if self.last_name_kana.present?
        self.last_name_kana.upcase!
        end
        if self.first_name_kana.present?
        self.first_name_kana.upcase!
        end
    end

    #company search by student
    def self.company_search_by_association(param)
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        @results = Company::Company.select('companies.*,m_industries.industry_name')
        .joins(:m_industries).where("companies.delete_flg = false #{param == "" ? param : 'AND '+ param}").to_a
    end

    #vacancy search by student
    def self.vacancy_search_by_association(param)
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        @results = Company::Vacancy.select('company_vacancies.*,companies.company_name,m_industries.industry_name,m_occupations.occupation_name')
        .joins(:company,:m_industries,:m_occupations)
        .where("CURRENT_DATE BETWEEN company_vacancies.display_from AND company_vacancies.display_to AND company_vacancies.published_flg = true AND company_vacancies.delete_flg = false #{param == "" ? param : 'AND '+ param}").to_a
    end

    #serach event by student
    def self.event_search_by_association(param)
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        Company::Event.where("CURRENT_DATE BETWEEN company_events.post_start_date AND company_events.post_end_date AND company_events.delete_flg = false #{param == "" ? param : 'AND '+ param}").order(application_deadline: :asc).to_a
    end

    #get favourite company list
    def get_favourite_company_list(student_id)
        Company::Company.select("companies.*,apply_favourite_transictions.std_com_favourite,m_industries.industry_name")
        .joins(:m_industries,:apply_favourite_transictions)
        .where("companies.delete_flg = false and apply_favourite_transictions.std_com_favourite = ? and apply_favourite_transictions.student_id = ?", true, student_id)
    end

    #get favourite vacancy list
    def get_favourite_vacancy_list(student_id)
        Company::Vacancy.select("company_vacancies.*,companies.company_name,m_industries.industry_name,m_occupations.occupation_name,apply_favourite_transictions.std_job_favourite")
        .joins(:company,:m_industries,:m_occupations,:apply_favourite_transictions)
        .where("company_vacancies.delete_flg = false and apply_favourite_transictions.std_job_favourite = ? and apply_favourite_transictions.student_id = ?", true, student_id)
    end

    #get favourite event list
    def get_favourite_event_list(student_id)
        Company::Event.select("company_events.*,companies.company_name,apply_favourite_transictions.event_favourite")
        .joins(:company,:apply_favourite_transictions)
        .where("company_events.delete_flg = false and apply_favourite_transictions.event_favourite = ? and apply_favourite_transictions.student_id = ?", true, student_id)
    end

    #get published event list
    def get_join_event_list(student_id)
        Company::Event.select("company_events.*,companies.company_name,apply_favourite_transictions.event_join")
        .joins(:company,:apply_favourite_transictions)
        .where("company_events.delete_flg = false and apply_favourite_transictions.event_join = ? and apply_favourite_transictions.student_id = ?", true, student_id)
    end    

    # get Top3 Favourite Student
    def show_top_3_fav_student()
        Student::Student.select("count(apply_favourite_transictions.student_id) AS fav_count,CONCAT(last_name, ' ', first_name) AS student_name,apply_favourite_transictions.student_id")
        .joins(:apply_favourite_transictions)
        .where("date(apply_favourite_transictions.created_at) >= '#{Date.today.at_beginning_of_month.strftime('%Y-%m-%d')}' and date(apply_favourite_transictions.created_at) <= '#{Date.today.end_of_month.strftime('%Y-%m-%d')}' and apply_favourite_transictions.com_std_favourite = true and students.delete_flg = 'false'")
        .group("apply_favourite_transictions.student_id,CONCAT(last_name, ' ', first_name)")
        .order("count(apply_favourite_transictions.student_id) DESC")
    end

    # get Student Count By Region
    def get_student_count_by_region()
        Student::Student.select("count(students.id) AS std_count,COALESCE( NULLIF(m_regions.region_name,'') ,'未選択') AS region")
        .left_joins(:m_regions)
        .where("date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' and students.delete_flg = 'false'")
        .group('m_regions.id,m_regions.region_name')
        .order('m_regions.id')
    end

    # get Student Count By School Type
    def get_student_count_by_schooltype()
        Student::Student.select("count(students.id) AS std_count,COALESCE( NULLIF(school_type,NULL) ,0) AS schooltype")
        .where("date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND delete_flg = 'false'")
        .group('school_type')
        .order('school_type')
    end

    # get Student Count By Pando Info
    def get_student_count_by_pandoinfo()
        Student::Student.select("count(students.id) AS std_count,CASE WHEN pando_info ISNULL OR pando_info = '' THEN '未登録' ELSE '登録' END AS pandoinfo")
        .where("date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND delete_flg = 'false'")
        .group('pandoinfo')
    end
end