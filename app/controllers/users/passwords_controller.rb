# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  before_action :set_user_type, only: [:new ,:create,:edit,:update]
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # PUT /resource/password
  def update
    super
  end

  protected

  def after_resetting_password_path_for(resource)
      new_session_path(resource,user_type: resource.user_type)
    # super(resource)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    # super(resource_name)
    new_session_path(resource_name,user_type: resource.user_type)
  end

  def set_user_type
    @user_type = params[:user_type]
  end 
end
