class CreateBackupDb < ActiveRecord::Migration[6.1]
  def change
    create_table :backup_dbs do |t|
      t.string :name
      t.string :backup_schedule
      t.string :destroy_schedule
      t.string :remark
      t.string :file_type
      t.string :backup_job_id
      t.string :delete_job_id
      t.date :delete_date
      t.timestamps
    end
  end
end
