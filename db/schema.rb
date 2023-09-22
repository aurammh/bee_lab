# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_26_061329) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "admin_code", limit: 20
    t.string "last_name", limit: 100
    t.string "first_name", limit: 100
    t.integer "user_type"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "apply_favourite_transictions", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "company_id"
    t.bigint "job_id"
    t.boolean "std_com_favourite", default: false, comment: " default = false, applied = true"
    t.boolean "std_job_favourite", default: false, comment: " default = false, applied = true"
    t.boolean "com_std_favourite", default: false, comment: " default = false, applied = true"
    t.boolean "std_job_apply", default: false, comment: " default = false, applied = true"
    t.date "action_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_apply_favourite_transictions_on_company_id"
    t.index ["student_id"], name: "index_apply_favourite_transictions_on_student_id"
  end

  create_table "companies", force: :cascade do |t|
    t.bigint "user_id"
    t.string "company_name", limit: 255
    t.string "company_name_kana", limit: 255
    t.string "postal_code", limit: 10
    t.string "address", limit: 255
    t.string "display_address", limit: 255
    t.string "phone_no", limit: 20
    t.string "company_info", limit: 255
    t.string "website_url", limit: 255
    t.bigint "m_industry_id"
    t.bigint "m_region_id"
    t.bigint "m_prefecture_id"
    t.string "postalcode_city"
    t.string "job_info"
    t.string "company_established"
    t.string "capital_amount"
    t.bigint "employee_count"
    t.string "sales_amount"
    t.string "related_company"
    t.string "main_bank"
    t.string "representative"
    t.string "contact"
    t.string "history"
    t.string "transportation_facilities"
    t.bigint "avg_service_year"
    t.string "avg_overtime_per_month"
    t.string "avg_paid_leaves"
    t.string "number_eligible_childcare_leaves_male"
    t.string "taken_childcare_leaves_male"
    t.string "childcare_leave_acquisition_rate_male"
    t.string "number_eligible_childcare_leaves_female"
    t.string "taken_childcare_leaves_female"
    t.string "rate_taken_childcare_leaves_female"
    t.boolean "delete_flg", default: false
    t.string "basic_idea"
    t.string "percentage_female_ration"
    t.string "percentage_training"
    t.integer "mentor_system"
    t.integer "career_consulting_system"
    t.string "in_house_certification_system"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "company_assessments", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.integer "seek_student_thinking_type", array: true
    t.integer "com_priority_item_type", array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_assessments_on_company_id"
  end

  create_table "company_events", force: :cascade do |t|
    t.bigint "company_id"
    t.string "event_code"
    t.integer "category", array: true
    t.string "event_name"
    t.date "event_start_date"
    t.date "event_end_date"
    t.string "venue"
    t.date "post_start_date"
    t.date "post_end_date"
    t.date "application_deadline"
    t.string "event_content"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_events_on_company_id"
  end

  create_table "company_vacancies", force: :cascade do |t|
    t.bigint "company_id"
    t.string "vacancy_title", limit: 255
    t.text "vacancy_description"
    t.string "postal_code", limit: 255
    t.bigint "m_region_id"
    t.bigint "m_prefecture_id"
    t.string "postalcode_city"
    t.string "address", limit: 255
    t.string "display_address", limit: 255
    t.bigint "recruit_industry_type"
    t.bigint "recruit_job_type"
    t.integer "required_applicants"
    t.bigint "basic_salary"
    t.string "model_salary"
    t.string "allowance"
    t.string "bonus"
    t.boolean "promotion"
    t.boolean "probation"
    t.boolean "transportation_allowance"
    t.boolean "dormitory"
    t.boolean "insurance"
    t.boolean "severance_pay"
    t.string "working_hours", limit: 255
    t.string "break_time", limit: 255
    t.boolean "over_time"
    t.string "other"
    t.string "hiring_flow_data", array: true
    t.string "holiday", limit: 255
    t.integer "welfare_list_data", array: true
    t.integer "company_enhancement", array: true
    t.date "display_from"
    t.date "display_to"
    t.string "other_skill", limit: 255
    t.boolean "published_flg"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_vacancies_on_company_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "company_name"
    t.text "content_inquiry"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_industries", force: :cascade do |t|
    t.string "industry_name", comment: "select the type of industry on screen"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_occupations", force: :cascade do |t|
    t.string "occupation_name", comment: "select the type of occupation name on screen"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_prefectures", force: :cascade do |t|
    t.bigint "m_region_id"
    t.string "prefecture_name", comment: "select the type of List of prefecture denpen on region"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["m_region_id"], name: "index_m_prefectures_on_m_region_id"
  end

  create_table "m_qualification_details", force: :cascade do |t|
    t.bigint "m_qualification_id"
    t.string "qualification_type", comment: "select the type of List of qualification denpen on qualification type"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["m_qualification_id"], name: "index_m_qualification_details_on_m_qualification_id"
  end

  create_table "m_qualifications", force: :cascade do |t|
    t.string "qualification_category", comment: "select the type of qualification List on screen"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_regions", force: :cascade do |t|
    t.string "region_name", comment: "select the type of region on screen"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_welfare_details", force: :cascade do |t|
    t.bigint "m_welfare_id"
    t.string "welfare_type", comment: "select the type of List of benefits denpen on welfares type"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["m_welfare_id"], name: "index_m_welfare_details_on_m_welfare_id"
  end

  create_table "m_welfares", force: :cascade do |t|
    t.string "welfare_category", comment: "select the type of List of benefits or welfares on screen"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "student_assessments", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.string "appeal_point_title_1"
    t.text "appeal_point_article_1"
    t.string "appeal_point_title_2"
    t.text "appeal_point_article_2"
    t.string "appeal_point_title_3"
    t.text "appeal_point_article_3"
    t.integer "logical_and_rational", array: true
    t.integer "solid_and_planned", array: true
    t.integer "sensory_and_friendly", array: true
    t.integer "adventurous_and_original", array: true
    t.integer "love_and_desire_to_belong", array: true
    t.integer "desire_for_power_and_value", array: true
    t.integer "desire_for_freedom", array: true
    t.integer "desire_for_fun", array: true
    t.integer "desire_for_survival", array: true
    t.integer "self_expression", array: true
    t.integer "self_assertion", array: true
    t.integer "self_flexibility", array: true
    t.integer "first_priority_language"
    t.integer "second_priority_language"
    t.integer "third_priority_language"
    t.integer "english_qualification"
    t.integer "toefl_test"
    t.integer "toeic_test"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["student_id"], name: "index_student_assessments_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.bigint "user_id"
    t.string "nick_name"
    t.string "confirm_email_one"
    t.string "confirm_email_two"
    t.string "last_name", limit: 100
    t.string "first_name", limit: 100
    t.string "last_name_kana", limit: 100
    t.string "first_name_kana", limit: 100
    t.integer "gender"
    t.date "birthday"
    t.string "email_two"
    t.boolean "delete_flg", default: false
    t.string "postal_code", limit: 255
    t.bigint "postal_region_id"
    t.bigint "postal_prefecture_id"
    t.string "postalcode_city"
    t.string "address", limit: 255
    t.string "display_address", limit: 255
    t.string "phone_no", limit: 20
    t.integer "school_type"
    t.string "school_name"
    t.string "department_name"
    t.integer "subject_system"
    t.string "graduation_date"
    t.integer "desire_industry_type_id", array: true
    t.integer "desire_job_type_id", array: true
    t.integer "m_region_id"
    t.integer "m_prefecture_id", array: true
    t.string "transfer"
    t.integer "qualification_category_id", array: true
    t.integer "qualification_type_id", array: true
    t.string "club_name"
    t.string "club_position"
    t.string "club_detail_activity"
    t.integer "outside_school_activity", array: true
    t.string "club_guide"
    t.boolean "is_beelab_activity_participate", default: true, comment: "deleted = true"
    t.string "beelab_college_achievements"
    t.string "attachment_for_pr"
    t.string "sns_blog_for_pr"
    t.string "pando_info"
    t.string "job_info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "user_name"
    t.integer "user_type"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "company_assessments", "companies"
  add_foreign_key "company_vacancies", "companies"
  add_foreign_key "student_assessments", "students"
end
