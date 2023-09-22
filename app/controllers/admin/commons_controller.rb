class Admin::CommonsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_admin_setting, only: %i[ admin_password_change password_update]
    layout 'layouts/template/admin'

    def admin_password_change
      render "admin/admins/admin_setting/admin_password_change"
    end
    
    def password_update
        @admin.check_current_password = true
        if Admin.find(current_admin.id).valid_password?(admin_setting_params[:current_password])
            @admin.check_password = true
            respond_to do |format|
                if @admin.update(admin_setting_params)
                  bypass_sign_in(@admin)
                  flash[:password_change] =I18n.t('admin.setting.admin_pwd_change')
                  format.html { redirect_to admin_password_change_path()}
                  format.json { head :no_content }
                else
                  format.html { render "admin/admins/admin_setting/admin_password_change" }
                  format.json { render json: @admin.errors, status: :unprocessable_entity }
                end
              end
            
        else
            respond_to do |format|
                @admin.assign_attributes(admin_setting_params)
                @admin.valid?
                @admin.errors.add(:current_password, t("errors.messages.is_wrong"))
                flash[:password] = @admin.errors.full_messages_for(:password)[0]
                format.html { render "admin/admins/admin_setting/admin_password_change" }
                format.json { render json: @admin.errors, status: :unprocessable_entity }
              end
        end
    end
    
    def set_permission
      user = User.find(params[:user_id])
      permission = Admin::Permission.find_by(admin_permission_type_id: params[:type_id],user_id: params[:user_id])
      if permission.present?
        Admin::Permission.transaction do
            permission.destroy
        end
      else
        Admin::Permission.transaction do
          permis_data = Admin::Permission.new
          permis_data.admin_permission_type_id = params[:type_id]
          permis_data.user_id = params[:user_id]
          permis_data.create_user = "#{current_admin.first_name} #{current_admin.last_name}"
          permis_data.user_type = user.user_type
          permis_data.ip_address = request.ip 
          permis_data.save!
        end
      end
      
    end

    private

    def set_admin_setting
        @admin = current_admin
    end

    def admin_setting_params
        params.require(:admin).permit(:password, :password_confirmation, :current_password)
      end
end