class User < ApplicationRecord
  has_one :company, class_name: "Company::Company", :inverse_of => :user, foreign_key: "user_id", dependent: :destroy
  has_one :student, class_name: "Student::Student", foreign_key: "user_id", dependent: :destroy
  has_one :permission, class_name: "Admin::Permission", foreign_key: "user_id", dependent: :destroy
  # accepts_nested_attributes_for :company, reject_if: :all_blank
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :validatable, :confirmable, authentication_keys: [:login,:user_type]

   #search update active flag from admin
   scope :admin_student_setting_all, -> { select("users.*,students.id as std_id,students.birthday,students.last_name || ' ' ||students.first_name as name").joins(:student).where("students.delete_flg='false'").order('first_name')}
   student_columnName = ["email","(CASE WHEN birthday IS NULL THEN '本登録未完了' ELSE '本登録完了' END)"]
   scope :admin_student_search_setting, ->(name, keyword) { 
    keyword_search = keyword.nil? ? '' : " AND (#{student_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    name_search = name.nil? ? '' : " AND (lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{name}%')"
    select("users.*,students.id as std_id, students.birthday,students.last_name || ' ' ||students.first_name as name")
    .joins(:student)
    .where("students.delete_flg='false'" + name_search + keyword_search)
    .order('first_name') } 
   
   scope :admin_company_setting_all, -> { select('users.*,companies.id as com_id ,companies.company_name_kana , companies.company_name as cp_name').joins(:company).where("companies.delete_flg='false'").order('company_name')}
   columnName = ["user_name","email","(CASE WHEN company_name_kana IS NULL THEN '本登録未完了' ELSE '本登録完了' END)"]
   scope :admin_company_search_setting, ->(name, keyword) {
    keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    name_search = name.nil? ? '' : " AND lower(companies.company_name) LIKE lower('%#{name}%')"
    select('users.*,companies.id as com_id ,companies.company_name_kana , companies.company_name as cp_name')
    .joins(:company)
    .where("companies.delete_flg='false'" + name_search + keyword_search)
    .order('company_name') }      

  validates :email,:format => { :with => VALID_EMAIL_REGEX, message: "がフォーマット正しくありません。" }, presence: true,on: :create

  attr_accessor :login, :last_name, :first_name,:company_name,:company_email,:terms_and_conditions,:privacy_policy
  validates :terms_and_conditions, acceptance: true
  validates :privacy_policy, acceptance: true
  validates :last_name,  length: { maximum: 255 }, presence: true,on: :create, if: -> {user_name.blank? && company_name.blank?  && is_student?}
  validates :first_name, length: { maximum: 255 }, presence: true ,on: :create, if: -> {user_name.blank? && company_name.blank?  && is_student?}
  validates :company_name,  length: { maximum: 255 }, presence: true,on: :create, if: -> { last_name.blank? && first_name.blank? && is_company?}
  validates :user_name, presence: true, uniqueness: true, length: { maximum: 255 }, on: :create, if: -> {last_name.blank? && first_name.blank? && is_company? }

  # after_create :skip_confirmation!
  # for user setting
  attr_accessor :check_password, :current_password, :chk_edit_username, :check_username, :check_current_password, :check_update, :chk_pass_edit,:chk_edit_email,:check_email
  validates :user_name, uniqueness: true, length: { maximum: 255 }, presence: true,on: :update, if: :check_username
  validates :email, uniqueness: true, length: { maximum: 255 }, presence: true,on: :update, if: :check_email
  # password validation
  validates :current_password, presence: true, if: :check_current_password
  validates :password, presence: true, if: :check_password
  validates_confirmation_of :password, if: :check_password


  def is_student?
    user_type == 2 ? true : false
  end

  def is_company?
    user_type == 1 ? true : false
  end
  
  def login
    @login || self.user_name || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    k= 'user_type'
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(user_name) = :value OR lower(email) = :value AND user_type = :type AND delete_flg = false" , { :value => login.downcase, :type => conditions[k.to_sym].to_i}]).first
    elsif conditions.has_key?(:user_name) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  private

  def password_required?
    if self.check_update
      if self.check_password
        return true
        super
      else
        return false
      end
    else
      new_record? ? false : super
    end
  end
end
