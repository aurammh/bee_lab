class MQualification < ApplicationRecord
    has_many :m_qualification_details, class_name: "MQualificationDetail"
end
