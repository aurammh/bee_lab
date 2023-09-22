class CreateStudentAssessments < ActiveRecord::Migration[6.1]
  def change
    create_table :student_assessments do |t|
      t.belongs_to :student ,null: false, foreign_key: true
      t.string :appeal_point_title_1
      t.text :appeal_point_article_1
      t.string :appeal_point_title_2
      t.text :appeal_point_article_2
      t.string :appeal_point_title_3
      t.text :appeal_point_article_3
      t.integer :logical_and_rational , array: true, using: "ARRAY[logical_and_rational]::INTEGER[]"
      t.integer :solid_and_planned , array: true, using: "ARRAY[solid_and_planned]::INTEGER[]"
      t.integer :sensory_and_friendly , array: true, using: "ARRAY[sensory_and_friendly]::INTEGER[]"
      t.integer :adventurous_and_original , array: true, using: "ARRAY[adventurous_and_original]::INTEGER[]"
      t.integer :love_and_desire_to_belong , array: true, using: "ARRAY[love_and_desire_to_belong]::INTEGER[]"
      t.integer :desire_for_power_and_value , array: true, using: "ARRAY[desire_for_power_and_value]::INTEGER[]"
      t.integer :desire_for_freedom , array: true, using: "ARRAY[desire_for_freedom]::INTEGER[]"
      t.integer :desire_for_fun , array: true, using: "ARRAY[desire_for_fun]::INTEGER[]"
      t.integer :desire_for_survival , array: true, using: "ARRAY[desire_for_survival]::INTEGER[]"
      t.integer :self_expression , array: true, using: "ARRAY[desire_for_survival]::INTEGER[]"
      t.integer :self_assertion , array: true, using: "ARRAY[desire_for_survival]::INTEGER[]"
      t.integer :self_flexibility , array: true, using: "ARRAY[desire_for_survival]::INTEGER[]"
      t.integer :first_priority_language
      t.integer :second_priority_language
      t.integer :third_priority_language
      t.integer :english_qualification
      t.integer :toefl_test
      t.integer :toeic_test
      t.date :brain_action_date
      t.date :potential_action_date
      t.date :behavioral_action_date
      t.timestamps
    end
  end
end
