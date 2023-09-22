class CreateAdminMPermissionTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_m_permission_types do |t|
      t.string :permission_type
      t.boolean :use_student, default: true
      t.boolean :use_company, default: true
      t.boolean :delete_flg, default: false
      t.timestamps
    end
  end
end
