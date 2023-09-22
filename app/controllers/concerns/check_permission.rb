module CheckPermission
    extend ActiveSupport::Concern
    included do
      before_action :check_permission
    end
  
    # 権限チェック
    def check_permission
     @permission_list = permission_list = Array.new
     permissions = Admin::Permission.where(user_id: current_user.id, user_type: current_user.user_type)
     @permission_list = permissions.map { |data| data.admin_permission_type_id} unless permissions.nil?
    end
  end