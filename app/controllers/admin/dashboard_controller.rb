class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  layout 'layouts/template/admin'
  include Student::StudentsHelper
  include Admin::DashboardHelper

  def index
    searchDate = params[:searchDate].blank? ? nil : params[:searchDate]
    start_date = searchDate.nil? || searchDate.empty?? Date.today.at_beginning_of_month : Date.new(searchDate.split('-')[0].to_i, searchDate.split('-')[1].delete_prefix("0").to_i)
    end_date = (start_date >> 1) - 1
    @year_month = searchDate.nil? || searchDate.empty?? Date.today.strftime('%Y-%m') : searchDate 

    student_info
    company_info 

    monthNum = params[:month_num] 
    @studentCountListResult = []
    @companyCountListResult = []
    @dateArrayListForLabel = []
    @genderLabel = []
    @studentCountListByGenderResult = []

    # Top 3 Favourite Company
    @top3FavouriteCompany = Company::Company.new.show_top_3_fav_company().limit(3)
    
    # Top 3 Favourite Student
    @top3FavouriteStudent = Student::Student.new.show_top_3_fav_student().limit(3)

    # Student Gender Dognut Chart
    studentCountListByGender = Student::Student.find_by_gender()
    @studentCountListByGenderResult = studentCountListByGender.blank? ? [] : studentCountListByGender.map{|data| [data.studentcount]}
    @genderLabel = studentCountListByGender.blank? ? [] : studentCountListByGender.map{|data| t("student.gender.#{Student::Student.genders.key(data.gender_name)}")}

    # Student Region Dognut Chart
    studentCountListByRegion = Student::Student.new.get_student_count_by_region()
    @studentResultCountByRegion = studentCountListByRegion.blank? ? []: studentCountListByRegion.map{|data| [data.std_count]} 
    @regionNameLabel = studentCountListByRegion.blank? ? []: studentCountListByRegion.map{|data| data.region}

    # Student SchoolType Dognut Chart
    studentCountListBySchoolType = Student::Student.new.get_student_count_by_schooltype()
    @studentCountListBySchoolTypeResult = studentCountListBySchoolType.blank? ? [] : studentCountListBySchoolType.map{|data| [data.std_count]}
    @schoolTypeLabel = studentCountListBySchoolType.blank? ? [] : studentCountListBySchoolType.map{|data| data.schooltype ==0? "未選択" : t("student.school_type.#{Student::Student.school_types.key(data.schooltype)}")}    
    
    # Student Pando Info Dognut Chart
    studentCountListByPandoInfo = Student::Student.new.get_student_count_by_pandoinfo()
    @studentCountListByPandoInfoResult = studentCountListByPandoInfo.blank? ? [] : studentCountListByPandoInfo.map{|data| [data.std_count]}
    @pandoInfoLabel = studentCountListByPandoInfo.blank? ? [] : studentCountListByPandoInfo.map{|data| [data.pandoinfo]}

    # Total Student Count & Company Count
    @studentCountList = Student::Student.find_by_date(start_date,end_date)
    @companyCountList = Company::Company.find_by_date(start_date,end_date)    

    date_array = Hash.new
    (start_date).upto(end_date).each_with_index do |day,index|
      date_array[day.strftime('%Y-%m-%d')] = index
      @dateArrayListForLabel[index] = day.strftime('%-d日')
      @studentCountListResult[index] = 0
      @companyCountListResult[index] = 0     
    end
    
    @studentCountList.each do |data|
        @studentCountListResult[date_array[data.created_at.strftime('%Y-%m-%d')].to_i] = data[:studentcount]
    end
    @companyCountList.each do |data|
      @companyCountListResult[date_array[data.created_at.strftime('%Y-%m-%d')].to_i] = data[:companycount]
    end
    arr = [@studentCountListResult,@companyCountListResult]
    @maxValue = arr.map{|x| x.max}                       
  end
  
  #For Admin Sing_IN
  def admin
    redirect_to(new_admin_session_path)
  end
end