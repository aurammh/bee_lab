class MWelfare < ApplicationRecord
    has_many :m_welfare_details, class_name: "MWelfareDetail"
end
