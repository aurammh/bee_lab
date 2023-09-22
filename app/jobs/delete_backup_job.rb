class DeleteBackupJob < ApplicationJob
  include Admin::BackupDbHelper
  queue_as :default

  def perform(id)
    admin_backup_db = Admin::BackupDb.find(id)
    de_date = get_delete_date(admin_backup_db.destroy_schedule, admin_backup_db.delete_date)
    backup_db_details = Admin::BackupDetail.where("backup_dbs_id = ? AND created_at < ?", id,
    de_date.beginning_of_day)
    if backup_db_details.present?
      backup_db_details.each do |backup| 
        if backup.file_type.attached?
          backup.file_type.purge
        end
      end
    backup_db_details.destroy_all
    end
    job =  self.class.set(:wait_until => get_destory_scheduletime(admin_backup_db.destroy_schedule)).perform_later(id)
    admin_backup_db.update_columns(delete_date: de_date,delete_job_id: job.provider_job_id)
  end
end