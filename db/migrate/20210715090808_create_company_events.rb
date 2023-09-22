class CreateCompanyEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :company_events do |t|
      t.belongs_to :company
      t.string :event_code
      t.integer :category, array: true, using: "ARRAY[category]::INTEGER[]"
      t.string :event_name
      t.date :event_start_date
      t.date :event_end_date
      t.string :venue
      t.date :post_start_date
      t.date :post_end_date
      t.date :application_deadline
      t.string :event_content
      t.boolean :delete_flg, default: false
      t.timestamps
    end
  end
end
