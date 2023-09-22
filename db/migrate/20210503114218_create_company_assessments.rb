class CreateCompanyAssessments < ActiveRecord::Migration[6.1]
  def change
    create_table :company_assessments do |t|
      t.belongs_to :company, null: false, foreign_key: true
      t.integer :seek_student_thinking_type, array: true, using: "ARRAY[seek_student_thinking_type]::INTEGER[]"
      t.integer :com_priority_item_type, array: true, using: "ARRAY[com_priority_item_type]::INTEGER[]"
      t.timestamps
    end
  end
end
