# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :set_user_type, only: [:new, :create]
  # before_action :configure_account_update_params, only: [:update]


  #set data for global user_type
  @@type = 0

  #this function is called from other Class
  def self.set_userType(data)
    @@type = data
  end

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super do 
      if resource.save
        if resource.user_type == 2
          student = Student::Student.new
          student.user_id = resource.id
          student.first_name = params[:user][:first_name]
          student.last_name = params[:user][:last_name]
          student.save(validate: false)
        else
          company = Company::Company.new
          company.user_id = resource.id
          company.company_name = params[:user][:company_name]
          company.save(validate: false)
        end
      else
        @user_type = resource.user_type
      end
      
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email,:password, :user_name, :user_type, :last_name, :company_name, :first_name,:company_email,:terms_and_conditions, :privacy_policy])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    welcome_registration_complete_path(user_type: resource.user_type)
    # super(resource)
  end
  def set_user_type
    @user_type = @@type
  end 
end
