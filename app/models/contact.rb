class Contact < ApplicationRecord
    validates :classification,presence: true
    validates :name, length: {maximum: 255},presence: true
    validates :email, length: {maximum: 255}, presence: true
    validates :company_name, length: {maximum: 255}
    validates :content_inquiry, presence: true
end
