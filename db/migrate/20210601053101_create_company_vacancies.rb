class CreateCompanyVacancies < ActiveRecord::Migration[6.1]
  def change
    create_table :company_vacancies do |t|
      t.references :company, null: true, foreign_key: true 
      t.string :vacancy_title , limit: 255
      t.text :vacancy_description
      t.string :postal_code, limit: 255
      t.bigint :m_region_id
      t.bigint :m_prefecture_id
      t.string :postalcode_city
      t.string :address, limit: 255 
      t.string :display_address, limit: 255
      t.bigint :recruit_industry_type
      t.bigint :recruit_job_type
      t.integer :required_applicants
      t.integer :basic_salary, limit: 8
      t.string :model_salary
      t.string :allowance
      t.string  :bonus
      t.boolean :promotion
      t.boolean  :probation
      t.boolean :transportation_allowance
      t.boolean  :dormitory
      t.boolean :insurance
      t.boolean :severance_pay
      t.string :working_hours, limit: 255
      t.string :break_time, limit: 255
      t.boolean :over_time
      t.string :other
      t.string :hiring_flow_data, array: true, using: 'ARRAY[company_enhancement]::STRING[]'
      t.string :holiday, limit: 255
      t.integer :welfare_list_data, array: true, using: 'ARRAY[welfare_list_data]::INTEGER[]'
      t.integer :company_enhancement, array: true, using: 'ARRAY[company_enhancement]::INTEGER[]'
      t.date :display_from
      t.date :display_to
      t.string :other_skill, limit: 255
      t.boolean :published_flg
      t.boolean :delete_flg,default: false
      t.timestamps
    end
  end
end
