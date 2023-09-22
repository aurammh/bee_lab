class CreateMIndustries < ActiveRecord::Migration[6.1]
  def change
    create_table :m_industries do |t|
      t.string :industry_name,comment: 'select the type of industry on screen'
      t.boolean :delete_flag ,:default => 'false', comment: ' default = false, deleted = true'
      t.timestamps
    end
  end
end
