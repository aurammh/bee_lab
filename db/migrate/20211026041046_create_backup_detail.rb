class CreateBackupDetail < ActiveRecord::Migration[6.1]
  def change
    create_table :backup_details do |t|
      t.bigint :backup_dbs_id
      t.timestamps
    end
  end
end
