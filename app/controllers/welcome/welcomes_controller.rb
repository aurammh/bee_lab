class Welcome::WelcomesController < ApplicationController
  include Accessible
  skip_before_action :check_path, only: %i[privacy_index contact_index destroy term_condition_index contact_create]
  def index
    @usertype = "0"
  end

  def company_index
    @usertype = "1"
  end

  def student_index
    @usertype = "2"
  end

  def contact_index   
    @usertype = params[:user_type].nil? ? 0 : params[:user_type].to_i
    if user_signed_in?
      @usertype = current_user.user_type
    end
    @contact = Contact.new
    render "welcome/contact_privacy/contact_index"
  end

  def contact_create
    @contact = Contact.new(contact_params)
    respond_to do |format|
      if @contact.save
        Welcome::ContactUsMailer.with(contact: @contact).contact_email.deliver_now
        format.html { redirect_to welcome_contact_path(user_type: params[:user_type]), notice: 'この度はお問い合わせいただき誠にありがとうございます。弊社にてお送りいただきました内容を確認のうえ、折り返しご連絡させていただきます。' }
      else
        @usertype = params[:user_type].to_i
        format.html { render "welcome/contact_privacy/contact_index"}
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def privacy_index
    @usertype = params[:user_type].nil? ? 0 : params[:user_type].to_i
    if user_signed_in?
      @usertype = current_user.user_type
    end
    render "welcome/contact_privacy/privacy_index"
  end

  def term_condition_index
    @user_type = 0
    if user_signed_in?
      @user_type = current_user.user_type
    end
    render "welcome/contact_privacy/term_condition_index"
  end

  def registration_complete
  end

  def company_login
    Users::SessionsController.set_userType("1")
    redirect_to(user_session_path)
  end

  def company_register
    Users::RegistrationsController.set_userType("1")
    redirect_to(new_user_registration_path)
  end

  def student_login
    Users::SessionsController.set_userType("2")
    redirect_to(user_session_path)
  end

  def student_register
    Users::RegistrationsController.set_userType("2")
    redirect_to(new_user_registration_path)
  end


  private
  def contact_params
    params.require(:contact).permit(:name, :email, :company_name, :content_inquiry,:classification,:contact)
  end
end