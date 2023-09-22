class CreateMWelfareDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :m_welfare_details do |t|
      t.belongs_to :m_welfare
      t.string :welfare_type,comment: 'select the type of List of benefits denpen on welfares type'
      t.boolean :delete_flag ,:default => 'false', comment: ' default = false, deleted = true'
      t.timestamps
    end
  end
end
