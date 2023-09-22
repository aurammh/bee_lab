class CommonsController < ApplicationController
    before_action :authenticate_user!, except: [ :get_region_name_by_prefecturename,:genuine_password,:genuine_password_change]
    before_action :set_setting_user, only: %i[ user_setting user_setting_update genuine_password genuine_password_change]
    before_action :set_set_setting_user_token, only: %i[ genuine_password genuine_password_change]

    def user_setting
        # flash.clear
        render "users/user_setting/setting"
    end
    def user_setting_update
      flash.clear
      @setting_user.check_update = true
      @setting_user.check_current_password = true
      @setting_user.check_username = false
      @setting_user.check_password = false
      @setting_user.check_email = false
  
      @setting_user.check_username = true if user_setting_params[:chk_edit_username] == "1"
      @setting_user.check_email = true if user_setting_params[:chk_edit_email] == "1"
      @setting_user.check_password = true if user_setting_params[:chk_pass_edit] == "1"
      if User.find(current_user.id).valid_password?(user_setting_params[:current_password])
        respond_to do |format|
          if @setting_user.update(user_setting_params)
            flash[:email_change] = @setting_user.user_type == 2 ? "メールアドレスが更新されました。" : "ログインIDが更新されました。"
            format.html { redirect_to user_setting_path(scop_name: @setting_user.user_type == 2 ? "student" : "company")}
            format.json { head :no_content }
          else
            flash[:password] = @setting_user.errors.full_messages_for(:password)[0]
            flash[:password_confirmation] = "新しいパスワードとパスワードの確認入力が一致しません。"
            format.html { render "users/user_setting/setting" }
            format.json { render json: @setting_user.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          @setting_user.assign_attributes(user_setting_params)
          @setting_user.valid?
          @setting_user.errors.add(:current_password, t("errors.messages.is_wrong"))
          flash[:password] = @setting_user.errors.full_messages_for(:password)[0]
          flash[:password_notice] = @setting_user.errors.full_messages_for(:current_password)[0]
          format.html { render "users/user_setting/setting" }
          format.json { render json: @setting_user.errors, status: :unprocessable_entity }
        end
      end
    end
  

    def get_region_name_by_prefecturename
        prefecture = MPrefecture.find_by(prefecture_name: params[:name])
        region = prefecture.m_region
        region_data = {region_id: region.id , region_name: region.region_name , prefecture_id: prefecture.id ,prefecture_name: prefecture.prefecture_name}

        render json: region_data
    end

    def genuine_password
      if @setting_user.encrypted_password.blank?
        render "users/user_setting/genuine_password"
      else
        redirect_to root_path
      end
     
    end

    def genuine_password_change
      @setting_user.check_password = true
      respond_to do |format|
        if @setting_user.update(genuine_password_params)
          bypass_sign_in(@setting_user)
          if @setting_user.user_type == 1
            company = @setting_user.company
            format.html {redirect_to(edit_company_company_path(company,genuine_password: true))}
          else
            student = @setting_user.student
            format.html {  redirect_to(edit_student_student_path(student,genuine_password: true))}
          end
          format.json { head :no_content }
        else
          format.html { render "users/user_setting/genuine_password" }
          format.json { render json: @setting_user.errors, status: :unprocessable_entity }
        end
      end
    end

    private
    def set_setting_user
        @setting_user = current_user
    end
    def set_set_setting_user_token
      @setting_user = User.confirm_by_token(params[:confirmation_token])
    end

    def genuine_password_params
      params.require(:user).permit(:password, :password_confirmation,:confirmation_token)
    end
    def user_setting_params
      params.require(:user).permit(:email,:chk_edit_email ,:password, :password_confirmation, :current_password, :user_name, :chk_edit_username, :chk_pass_edit)
    end
end