class Admin::BackupDb < ApplicationRecord
    self.table_name = "backup_dbs"
    validates :name, length: { maximum: 255 }, presence: true
    validates :backup_schedule, length: { maximum: 255 }, presence: true,uniqueness: true
    validates :destroy_schedule, length: { maximum: 255 }, presence: true,uniqueness: true
    validates :file_type, length: { maximum: 255 }, presence: true

    #enum for backup_shedule options
    enum backup_shedule: { a_day: 1, weekely: 2, monthly: 3}
    #enum for destroy_shedule options
    enum destroy_shedule: { week: 1, month: 2, three_monthly: 3}
end
