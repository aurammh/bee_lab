class Admin::MPermissionType < ApplicationRecord
    has_one :permission, class_name: "Admin::Permission", foreign_key: "admin_permission_type_id", dependent: :destroy
end
