class CreateMQualificationDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :m_qualification_details do |t|
      t.belongs_to :m_qualification
      t.string :qualification_type,comment: 'select the type of List of qualification denpen on qualification type'
      t.boolean :delete_flag ,:default => 'false', comment: ' default = false, deleted = true'
      t.timestamps
    end
  end
end
