module Admin::DashboardHelper
  def student_info
    @totalStudent = Student::Student.all.where("delete_flg='false'")
    @fullyStudentRegisterCount = @totalStudent.select { |student| student[:birthday] != nil }.size()   
    @tempStudentRegisterCount = @totalStudent.select { |student| student[:birthday] == nil }.size()
    @fullyStudentRegisterAvg = @totalStudent.size() == 0? 0.0 : ((@fullyStudentRegisterCount.to_f / @totalStudent.size().to_f) * 100).round(2)
    @tempStudentRegisterAvg = @totalStudent.size() == 0? 0.0 : ((@tempStudentRegisterCount.to_f / @totalStudent.size().to_f) * 100).round(2)
  end

  def company_info
    @totalCompany = Company::Company.all.where("delete_flg='false'")
    vacancy_info = Company::Vacancy.select("Distinct company_id").where("delete_flg='false'")
    event_info = Company::Event.select("Distinct company_id").where("delete_flg='false'")
    eventDataNotInVacancy = event_info.select{ |event| !vacancy_info.include?(event[:company_id]) }.map{ |vacancy| vacancy[:company_id]}
    @eventCreateComCount = event_info.size()
    @vacancyCreateComCount = vacancy_info.size() 
    @fullyCompanyRegisterCount = @totalCompany.select { |company| company[:company_name_kana] != nil }.size()     
    @paymentCompanyRegisterCount = (event_info.map{|data| [data.company_id]} - vacancy_info.map{|data| [data.company_id]}).size() + vacancy_info.size()
    @fullyCompanyRegisterAvg = @totalCompany.size() == 0? 0.0 : ((@fullyCompanyRegisterCount.to_f / @totalCompany.size()) * 100).round(2)
    @paymentCompanyRegisterAvg = @totalCompany.size() == 0? 0.0 : ((@paymentCompanyRegisterCount.to_f / @totalCompany.size()) * 100).round(2)
    @eventCreateComAvg = @totalCompany.size() == 0? 0.0 : ((@eventCreateComCount.to_f / @totalCompany.size()) * 100).round(2)
    @vacancyCreateComAvg = @totalCompany.size() == 0? 0.0 : ((@vacancyCreateComCount.to_f / @totalCompany.size()) * 100).round(2)
  end
end
