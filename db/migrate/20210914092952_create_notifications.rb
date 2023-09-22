class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :record_type
      t.bigint :record_id
      t.bigint :sender_id
      t.bigint :receiver_id
      t.timestamps
    end
  end
end
