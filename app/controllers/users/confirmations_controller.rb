# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?
    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource){ redirect_to genuine_password_path(confirmation_token: resource.confirmation_token,scop_name: resource.user_type == 2 ? "student" : "company") }
    else
      # set_flash_message!(:notice, "#{resource.errors.full_messages}")
      Users::SessionsController.set_userType(resource.user_type.to_s)
      if resource.encrypted_password.blank?
        respond_with_navigational(resource.errors, status: :unprocessable_entity){redirect_to(genuine_password_path(confirmation_token: resource.confirmation_token,scop_name: resource.user_type == 2 ? "student" : "company")) } 
      else
        respond_with_navigational(resource.errors, status: :unprocessable_entity){redirect_to(user_session_path) }
      end
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      signed_in_root_path(resource)
    else
      Users::SessionsController.set_userType(resource.user_type.to_s)
      new_user_session_path
    end
    # super(resource_name, resource)
  end
end
