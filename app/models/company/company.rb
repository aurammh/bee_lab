class Company::Company < ApplicationRecord
    belongs_to :user , foreign_key: "user_id",optional: true
    belongs_to :m_industries, class_name: "MIndustry", foreign_key: "m_industry_id",optional: true
    belongs_to :m_prefectures, class_name: "MPrefecture", foreign_key: "m_prefecture_id",optional: true
    has_many :apply_favourite_transictions, class_name: "ApplyFavouriteTransiction", foreign_key: "company_id"
    has_many :company_vacancies, class_name: "Company::Vacancy"
    has_many :events, class_name: "Company::Event"
    has_one_attached :image
    has_one :assessment, class_name: "Company::Assessment", foreign_key: "company_id", dependent: :destroy
    self.table_name = "companies"

     # 管理者関連
     scope :find_by_date, -> (startDate, endDate){ select('date(created_at) AS created_at,count(id) AS companycount').where("date(created_at) >= '#{startDate}' and date(created_at) <= '#{endDate}' AND delete_flg = 'false'").group("date(created_at)") }
     #Search company with date by admin
     columnName = ["company_name","prefecture_name","industry_name","(CASE WHEN company_name_kana IS NULL THEN '本登録未完了' ELSE '本登録完了' END)","(CASE WHEN companies.id in (Select distinct company_id from company_vacancies) THEN 'あり' ELSE 'なし' END)","(CASE WHEN companies.id in (Select distinct company_id from company_events) THEN 'あり' ELSE 'なし' END)"]
     scope :admin_search_by_between_two_date, ->(startDate, endDate, keyword){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name, users.user_name, m_regions.region_name as region')
        .where(       
            "date(companies.created_at) >= '#{startDate}' AND date(companies.created_at) <= '#{endDate}' AND companies.delete_flg = 'false'" + keyword_search)
        .joins(:user)
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }

        scope :admin_search_by_only_start_date, ->(startDate, keyword){
            keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword}%')"}.join(' or ')})"
           select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name, users.user_name , m_regions.region_name as region')
           .where(       
               "date(companies.created_at) >= '#{startDate}' AND companies.delete_flg = 'false'" +keyword_search)
           .joins(:user)
           .joins("LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
           .order("created_at DESC")
           }

     scope :admin_search_by_only_end_date, ->(endDate, keyword){
         keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword}%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name, users.user_name , m_regions.region_name as region')
        .where(       
            "date(companies.created_at) <= '#{endDate}' AND companies.delete_flg = 'false'" +keyword_search)
        .joins(:user)
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }

    scope :admin_company_all_init_list, ->(keyword){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword}%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name, users.user_name , m_regions.region_name as region')
        .where(       
            " companies.delete_flg = 'false'" +keyword_search)
        .joins(:user)
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }

    #mail_setting enum
    enum mail_settings: {  unsent: 0, all_in_one: 1, five_in_one: 5, ten_in_one: 10 }

    validates :company_name, length: { maximum: 255 }, presence: true
    validates :company_name_kana, length: { maximum: 255 }, presence: true ,on: :update, if: :company_name_kana_changed?
    validates :website_url, presence: true, :format => { :with => VALID_URL_REGEX, message: "がフォーマット正しくありません。" }, length: { maximum: 255 }, on: :update, if: :website_url_changed?
    validates :phone_no, presence: true, length: { within: 6..20 }, on: :update, if: :phone_no_changed?
    validates :m_industry_id, length: { maximum: 8 }, presence: true, on: :update
    validates :company_info, length: { maximum: 255 }, presence: true, on: :update, if: :company_info_changed?
    validates :address, length: { maximum: 255 }, presence: true, on: :update, if: :address_changed?
    validates :contact, length: { maximum: 255 }, presence: true, on: :update, if: :contact_changed?
    validates :job_info, length: { maximum: 255 }, presence: true, on: :update, if: :job_info_changed?
    validates :company_established, length: { maximum: 60 }, presence: true, on: :update, if: :company_established_changed?
    validates :employee_count, length: { maximum: 16 }, presence: true, on: :update
    validates :main_bank, length: { maximum: 255 }, presence: true, on: :update, if: :main_bank_changed?
    validates :representative, length: { maximum: 255 }, presence: true, on: :update, if: :representative_changed?
    validates :postal_code, presence: true, on: :update, if: :postal_code_changed?
    validates :region_name, presence: true, on: :update, if: :m_region_id_changed?
    validates :prefecture_name, presence: true, on: :update, if: :m_prefecture_id_changed?
    validates :postalcode_city, presence: true, on: :update, if: :postalcode_city_changed?
    
    validates :capital_amount_string, length: { maximum: 16 }, presence: true,  format: { with: INT_REGEX, message: I18n.t('integer_format')} ,on: :update,if: :capital_amount_changed?
    validates :sales_amount_string,length: { maximum: 16 }, presence: true, format: { with: INT_REGEX, message: I18n.t('integer_format')}, on: :update, if: :sales_amount_changed?
    validates :avg_service_year_string, allow_blank: true, format: { with: INT_REGEX, message: I18n.t('integer_format')} ,on: :update,if: :avg_service_year_changed?
    validates :avg_overtime_per_month, allow_blank: true, format: { with: INT_REGEX, message: I18n.t('integer_format')} ,on: :update,if: :avg_overtime_per_month_changed?
    validates :avg_paid_leaves, allow_blank: true, format: { with: INT_REGEX, message: I18n.t('integer_format')} ,on: :update,if: :avg_paid_leaves_changed?
    validates :number_eligible_childcare_leaves_male, allow_blank: true, format: { with: INT_REGEX, message: I18n.t('integer_format')} ,on: :update,if: :number_eligible_childcare_leaves_male_changed?
    validates :taken_childcare_leaves_male, allow_blank: true, format: { with: INT_REGEX, message: I18n.t('integer_format')} ,on: :update,if: :taken_childcare_leaves_male_changed?
    validates :childcare_leave_acquisition_rate_male, allow_blank: true, format: { with: INT_REGEX, message: I18n.t('integer_format')} ,on: :update,if: :childcare_leave_acquisition_rate_male_changed?
    validates :number_eligible_childcare_leaves_female, allow_blank: true, format: { with: INT_REGEX, message: I18n.t('integer_format')} ,on: :update,if: :number_eligible_childcare_leaves_female_changed?
    validates :taken_childcare_leaves_female, allow_blank: true, format: { with: INT_REGEX, message: I18n.t('integer_format')} ,on: :update,if: :taken_childcare_leaves_female_changed?
    validates :rate_taken_childcare_leaves_female, allow_blank: true, format: { with: INT_REGEX, message: I18n.t('integer_format')} ,on: :update,if: :rate_taken_childcare_leaves_female_changed?
    validates :percentage_female_ration, allow_blank: true, format: { with: INT_REGEX, message: I18n.t('integer_format')} ,on: :update,if: :percentage_female_ration_changed?

   # for get/set number inputs
    attr_accessor :capital_amount_string,:sales_amount_string, :avg_service_year_string, :prefecture_name,:region_name

    before_validation(on: :update) do
        self.capital_amount = commaSperatorValidation(self.capital_amount_string)
        self.sales_amount = commaSperatorValidation(self.sales_amount_string)
        self.avg_service_year = commaSperatorValidation(self.avg_service_year_string)
    end

    def commaSperatorValidation(val)
        if val.to_s.strip.empty?
            return val
        else
            return val.tap { |s| s.delete!(',') }.to_i
        end
    end

    # To retrive student's info
    def search_student(parms1,params2)
        parms1 = parms1.delete_if { |a| a.empty? }
        parms2 = params2.delete_if { |a| a.empty? }
        param1 = parms1.join(" AND ")
        param2 = parms2.join(" AND ")
        @results = Student::Student.select('students.*')
        unless param2.nil?
            @results = @results.where(param2)
        end
        unless param1.nil?
            @results = @results.where(param1)
        end
        @results.to_a
    end

    #for show created vacancy list
    def get_vacancy_list(company_id)
        vacancy_list = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name')
        .joins(:m_industries,:m_occupations).where("company_id= ? and company_vacancies.delete_flg = ?", company_id, false).order(created_at: :desc)
        return vacancy_list
    end

    #for dashboard favourite list
    def get_favourite_list(company_id)
        favourite_list =  Student::Student.select("students.*,apply_favourite_transictions.com_std_favourite")
        .joins(:apply_favourite_transictions)
        .where("apply_favourite_transictions.com_std_favourite = ? and apply_favourite_transictions.company_id = ? and students.delete_flg = ?", true, company_id, false)
        return favourite_list
    end

    #select event list
    def get_event_entry_list(company_id)
        event_list = Company::Event.select('company_events.*')
        .where("company_events.company_id= ? and company_events.delete_flg = ? ", company_id,false).order(created_at: :desc)
        return event_list
    end

    #get student count who are join event
    def get_join_event_student_count(company_id)
        join_event_count = Company::Event.select('company_events.id,count(apply_favourite_transictions.student_id) as join_count')
        .joins(:apply_favourite_transictions)
        .where("apply_favourite_transictions.event_join= ? and company_events.company_id= ? and company_events.delete_flg = ?",true, company_id, false)
        .group("company_events.id,company_events.created_at").order(created_at: :desc)
        return join_event_count
    end

    # get student list who are join event
    def get_joined_event_student_list(event_id)
        join_event_list = Student::Student.select('students.*')
        .joins(:apply_favourite_transictions)
        .where("apply_favourite_transictions.event_join= ? and apply_favourite_transictions.event_id= ?",true, event_id)
        return join_event_list
    end

    # get Top3 Favourite Company
    def show_top_3_fav_company()
        Company::Company.select("count(apply_favourite_transictions.company_id) AS fav_count,companies.company_name,apply_favourite_transictions.company_id")
        .joins(:apply_favourite_transictions)
        .where("date(apply_favourite_transictions.created_at) >= '#{Date.today.at_beginning_of_month.strftime('%Y-%m-%d')}' and date(apply_favourite_transictions.created_at) <= '#{Date.today.end_of_month.strftime('%Y-%m-%d')}' and apply_favourite_transictions.std_com_favourite = true AND companies.delete_flg = 'false'")
        .group("apply_favourite_transictions.company_id,companies.company_name")
        .order("count(apply_favourite_transictions.company_id) DESC")
    end
end