class CreateCommunications < ActiveRecord::Migration[6.1]
  def change
    create_table :communications do |t|
      t.string :title
      t.string :category
      t.integer :sender_id
      t.integer :receiver_id
      t.string :content
      t.timestamps
    end
  end
end
