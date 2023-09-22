class CreateCommunicationDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_details do |t|
      t.belongs_to :communication
      t.integer :sender_id      
      t.integer :receiver_id
      t.string :content
      t.timestamps
    end
  end
end
