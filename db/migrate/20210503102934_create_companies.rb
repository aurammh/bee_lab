class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.belongs_to :user
      t.string :company_name, limit: 255
      t.string :company_name_kana, limit: 255
      t.string :postal_code, limit: 10
      t.string :address, limit: 255
      t.string :display_address, limit: 255
      t.string :phone_no, limit: 20
      t.string :company_info, limit: 255
      t.string :website_url, limit: 255
      t.bigint :m_industry_id
      t.bigint :m_region_id
      t.bigint :m_prefecture_id
      t.string :postalcode_city
      t.string :job_info
      t.string :company_established
      t.string :capital_amount
      t.string :employee_count
      t.string :sales_amount
      t.string :related_company
      t.string :main_bank
      t.string :representative
      t.string :contact
      t.string :history
      t.string :transportation_facilities
      t.bigint :avg_service_year
      t.string :avg_overtime_per_month
      t.string :avg_paid_leaves
      t.string :number_eligible_childcare_leaves_male
      t.string :taken_childcare_leaves_male
      t.string :childcare_leave_acquisition_rate_male
      t.string :number_eligible_childcare_leaves_female 
      t.string :taken_childcare_leaves_female 
      t.string :rate_taken_childcare_leaves_female  
      t.boolean :delete_flg, default: false
      t.string :basic_idea
      t.string :percentage_female_ration
      t.string :percentage_training
      t.integer :mentor_system
      t.integer :career_consulting_system
      t.string :in_house_certification_system
      t.integer :mail_setting,default: 0
      t.timestamps
    end
  end
end
