class Company::Vacancy < ApplicationRecord
    belongs_to :company , class_name: "Company::Company", foreign_key: "company_id"
    belongs_to :m_industries, class_name: "MIndustry", foreign_key: "recruit_industry_type",optional: true
    belongs_to :m_occupations, class_name: "MOccupation", foreign_key: "recruit_job_type",optional: true
    has_many :apply_favourite_transictions, class_name: "ApplyFavouriteTransiction", foreign_key: "job_id"
    self.table_name = "company_vacancies"
    attr_accessor :prefecture_name,:region_name,:required_applicants_string
    enum company_vacancy_enhancement: { disaster_support: 1, child_care_support: 2, work_env_support: 3, athletics_support: 4, property_support: 5 }

    columnName = ["company_name", "industry_name","occupation_name ","working_hours","required_applicants::text"]
    scope :admin_vacancy_search_by_between_two_date, ->(vacancy_startDate, vacancy_endDate, keyword){
      keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
      select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
      .where(       
       "date(company_vacancies.created_at)>= '#{vacancy_startDate}' AND date(company_vacancies.created_at) <= '#{vacancy_endDate}' AND (company_vacancies.delete_flg = 'false') " + keyword_search)
      .joins(:company,:m_industries,:m_occupations)
      .order("created_at DESC")
      }

    scope :admin_vacancy_search_by_start_date, ->(vacancy_startDate, keyword){
      keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
      select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
      .where(       
        "date(company_vacancies.created_at)>= '#{vacancy_startDate}' AND (company_vacancies.delete_flg = 'false') " + keyword_search)
      .joins(:company,:m_industries,:m_occupations)
      .order("created_at DESC")
      }

    scope :admin_vacancy_search_by_only_end_date, ->(vacancy_endDate, keyword){
       keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
       select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
       .where(       
        "date(company_vacancies.created_at) <= '#{vacancy_endDate}' AND (company_vacancies.delete_flg = 'false')" + keyword_search)
       .joins(:company,:m_industries,:m_occupations)
       .order("created_at DESC")
       }
    
    scope :admin_vacancy_init_list, ->(keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
    .where(       
      " (company_vacancies.delete_flg = 'false')" + keyword_search)
    .joins(:company,:m_industries,:m_occupations)
    .order("created_at DESC")
    }
    
    validates :vacancy_title, length: {maximum: 255}, presence: true
    validates :vacancy_description,length: {maximum: 255}, presence: true
    validates :recruit_industry_type,presence: true
    validates :recruit_job_type, presence: true
    validates :address, length: {maximum: 255}, presence: true
    validates :postal_code, length: {is: 7 }, presence: true
    validates :region_name, presence: true
    validates :prefecture_name, presence: true
    validates :postalcode_city, presence: true
    validates :other_skill, length: {maximum: 255}
    validates :allowance, presence: true
    validates :bonus,presence: true
    validates :model_salary,presence: true
    validates :required_applicants_string, length: {maximum: 8}, presence: true
    validates :basic_salary, length: {maximum: 8}, presence: true
    validates :working_hours, length: {maximum: 255}, presence: true
    validates :break_time, length: {maximum: 255}, presence: true
    validates :holiday, length: {maximum: 255}, presence: true
    validates :display_from, presence: true, on: [:create, :update]
    validates :display_to, presence: true, on: [:create, :update]
    validate :check_display_date

    before_validation(on: [:create, :update]) do
      self.required_applicants =  self.required_applicants_string.tap { |s| s.delete!(',') }.to_i unless self.required_applicants_string.nil? 
    end
    
    def check_display_date
      unless display_to.nil?
        if  display_from != nil && display_from > display_to
          errors.add(:display_to)
        end
      end
    end
end
