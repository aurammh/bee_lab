class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :classification
      t.string :name
      t.string :email
      t.string :company_name
      t.string :contact
      t.text :content_inquiry
      t.timestamps
    end
  end
end
