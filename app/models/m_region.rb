class MRegion < ApplicationRecord
    has_many :m_prefecture, class_name: "Mprefecture"
end
