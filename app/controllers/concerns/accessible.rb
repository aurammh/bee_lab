module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_path
  end

  protected
  def check_path
    if current_admin
      redirect_to(admin_dashboard_index_path) and return
    else
      if user_signed_in?
        permission = Admin::Permission.find_by(admin_permission_type_id: 1,user_id: current_user.id)
        if permission.nil?
          if current_user.user_type == 1
            check_company == true ? redirect_to(edit_company_company_path(@user_data)) : redirect_to(company_companies_path)
          else
            check_student == true ? redirect_to(edit_student_student_path(@user_data)) : redirect_to(student_students_path)
          end
        else
          Users::SessionsController.set_activeFlag(true)
          # current_user.invalidate_all_sessions!
          redirect_to logout_path and return
        end
        
      end
    end
  end
  def check_student
    @user_data.birthday == nil ? true : false
  end

  def check_company
    @user_data.m_industry_id == nil || @user_data.phone_no == nil ? true : false
  end
end
