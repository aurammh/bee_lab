class CreateApplyFavouriteTransictions < ActiveRecord::Migration[6.1]
  def change
    create_table :apply_favourite_transictions do |t|
      t.belongs_to :student
      t.belongs_to :company
      t.bigint :job_id
      t.bigint :event_id
      t.boolean :std_com_favourite,:default => 'false', comment: ' default = false, applied = true'
      t.boolean :std_job_favourite,:default => 'false', comment: ' default = false, applied = true'
      t.boolean :com_std_favourite,:default => 'false', comment: ' default = false, applied = true'
      t.boolean :std_job_apply,:default => 'false', comment: ' default = false, applied = true'
      t.boolean :event_favourite,:default => 'false', comment: ' default = false, applied = true'
      t.boolean :event_join,:default => 'false', comment: ' default = false, applied = true'
      t.date :action_date 
      t.timestamps
    end
  end
end
