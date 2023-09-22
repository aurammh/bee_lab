# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include Accessible
  skip_before_action :check_path, only: :destroy
  before_action :configure_sign_in_params, only: [:create]
  before_action :set_user_type, only: [:new ,:create]

  #set data for global user_type
  @@type = 0
  @@active_flag = false

  #this function is called from other Class
  def self.set_userType(data)
    @@type = data
  end

  def self.set_activeFlag(flag)
    @@active_flag = flag
  end

  def self.get_activeFlag
    @@active_flag
  end

  #GET /resource/sign_in
  # def new
  #   super
  # end

  ##POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    super do 
      flash.clear
    end
  end

  # protected
  def set_user_type
    @user_type = @@type
  end 
  
  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login,:password,:user_type])
  end
end
