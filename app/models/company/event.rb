class Company::Event < ApplicationRecord
    belongs_to :company , class_name: "Company::Company"
    has_many :apply_favourite_transictions, class_name: "ApplyFavouriteTransiction", foreign_key: "event_id"
    self.table_name = "company_events"
    has_one_attached :event_image

    enum event_category: { com_info_explancation: 1, related_com_explanation: 2, internship: 3, part_time_job_recruit: 4, other_session: 5 }
    columnName = ["company_name","event_name","venue"]
    scope :admin_event_search_by_between_two_date, ->(date_type, startDate, endDate, keyword, param){
       keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
       param = param.delete_if  {|a| a.empty?}
       param = param.join(" AND ")
       select("company_events.*, companies.company_name")
       .joins(:company)
        .where(       
           "date(company_events.#{date_type}) >= '#{startDate}' AND date(company_events.#{date_type}) <= '#{endDate}' AND company_events.delete_flg  = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
       )
       .order("event_start_date DESC")
       }

    scope :admin_event_search_by_start_date, ->(date_type, startDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("company_events.*, companies.company_name")
    .joins(:company)
    .where(       
        "date(company_events.#{date_type}) >= '#{startDate}' AND company_events.delete_flg  = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :admin_event_search_by_only_end_date, ->(date_type, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("company_events.*, companies.company_name")
    .joins(:company)
    .where(       
        "date(company_events.#{date_type}) <= '#{endDate}' AND company_events.delete_flg  =  'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :admin_event_search_init_list, ->(keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("company_events.*, companies.company_name")
    .joins(:company)
    .where(
      "company_events.delete_flg = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    validates :event_name, length: { maximum: 255 }, presence: true
    validates :venue, length: { maximum: 255 }, presence: true
    validates :category,presence: true
    validates :event_content, length: { maximum: 255 }, presence: true
    validates :event_start_date, presence: true, on: [:create, :update]
    validates :event_end_date, presence: true, on: [:create, :update]
    validates :post_start_date, presence: true, on: [:create, :update]
    validates :post_end_date, presence: true, on: [:create, :update]
    validates :application_deadline, presence: true, on: [:create, :update]
    validate :must_have_one_category

  def must_have_one_category
    errors.add(:category, 'を選択してください。') if self.category.length == 1 &&  self.category[0] == nil
  end
    
end