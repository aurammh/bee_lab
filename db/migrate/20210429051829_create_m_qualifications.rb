class CreateMQualifications < ActiveRecord::Migration[6.1]
  def change
    create_table :m_qualifications do |t|
      t.string :qualification_category,comment: 'select the type of qualification List on screen'
      t.boolean :delete_flag ,:default => 'false', comment: ' default = false, deleted = true'
      t.timestamps
    end
  end
end
