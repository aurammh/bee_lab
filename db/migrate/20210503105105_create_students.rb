class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.belongs_to :user
      t.string :nick_name
      t.string :last_name, limit: 100
      t.string :first_name, limit: 100
      t.string :last_name_kana, limit: 100
      t.string :first_name_kana, limit: 100
      t.integer :gender
      t.date :birthday
      t.string :email_two
      t.boolean :delete_flg, default: false
      t.string :postal_code, limit: 255
      t.bigint :postal_region_id
      t.bigint :postal_prefecture_id
      t.string :postalcode_city
      t.string :address, limit: 255
      t.string :display_address, limit: 255
      t.string :phone_no, limit: 20
      t.integer :school_type
      t.string :school_name
      t.string :department_name
      t.integer :subject_system
      t.string :graduation_date
      t.integer :desire_industry_type_id, array: true, using: "ARRAY[desire_industry_type]::INTEGER[]"
      t.integer :desire_job_type_id, array: true, using: "ARRAY[desire_job_type_id]::INTEGER[]"
      t.integer :m_region_id
      t.integer :m_prefecture_id, array: true, using: "ARRAY[desire_location_detail_id]::INTEGER[]"
      t.string :transfer
      t.integer :qualification_category_id, array: true, using: "ARRAY[qualification_category_id]::INTEGER[]"
      t.integer :qualification_type_id, array: true, using: "ARRAY[qualification_type_id]::INTEGER[]"
      t.string :club_name
      t.string :club_position
      t.string :club_detail_activity
      t.integer :outside_school_activity, array: true, using: "ARRAY[outside_school_activity]::INTEGER[]"
      t.string :club_guide
      t.boolean :is_beelab_activity_participate, comment: "deleted = true"
      t.string :beelab_college_achievements
      t.string :attachment_for_pr
      t.string :sns_blog_for_pr
      t.string :pando_info
      t.string :job_info
      t.timestamps
    end
  end
end
