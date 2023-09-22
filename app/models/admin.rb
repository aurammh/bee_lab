class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,:timeoutable,
         :recoverable, :rememberable, :validatable

         attr_accessor :check_password, :current_password, :check_current_password

    validates :current_password, presence: true, if: :check_current_password
    validates :password, presence: true, if: :check_password
    validates :password, confirmation: true, if: :check_password
    validates_confirmation_of :password, if: :check_password
end