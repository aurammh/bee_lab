class Company::Assessment < ApplicationRecord
    belongs_to :company , class_name: "Company::Company"
    self.table_name = "company_assessments"
    enum student_thinking_priority_order: { first_priority: 1, sec_priority: 2, third_priority: 3, fourth_priority: 4 }
    enum company_item_priority_order: { first_priority_item: 1, sec_priority_item: 2, third_priority_item: 3, fourth_priority_item: 4,fifth_priority_item: 5 }
end
