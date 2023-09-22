class CreateMWelfares < ActiveRecord::Migration[6.1]
  def change
    create_table :m_welfares do |t|
      t.string :welfare_category, comment: 'select the type of List of benefits or welfares on screen'
      t.boolean :delete_flag ,:default => 'false', comment: ' default = false, deleted = true'
      t.timestamps
    end
  end
end
