class ApplicationController < ActionController::Base
  before_action :set_user, if: :user_signed_in?
  include CheckPermission
  before_action :check_permission, if: :user_signed_in?
  # def after_sign_in_path_for(resource)
  #   if resource.user_type == 2
  #     student = resource.student
  #     return (edit_student_student_path(student))
  #   else
  #     company = resource.company
  #     return (edit_company_company_path(company))
  #   end
  # end

  private
  def set_user
    if current_user.user_type == 2
      @user_data = current_user.student
    else
      @user_data = current_user.company
    end  
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      new_admin_session_path
    else
      active_flag = Users::SessionsController.get_activeFlag
      if active_flag
        flash[:active_flag] = I18n.t('admin.setting.active_login_msg')
        Users::SessionsController.set_activeFlag(false)
        new_user_session_path 
      else
        root_path
      end
    end
  end
end
