Rails.configuration.after_initialize do
  include Admin::BackupDbHelper
  require 'sidekiq/api'
#    if ActiveRecord::Base.connection.table_exists? 'backup_dbs'
    admin_backup_dbs = Admin::BackupDb.all
    unless admin_backup_dbs.present?
        Sidekiq::Queue.all.each {|x| x.clear}

        # Clear retry set

        Sidekiq::RetrySet.new.clear

        # Clear scheduled jobs 

        Sidekiq::ScheduledSet.new.clear

        # Clear 'Dead' jobs statistics

        Sidekiq::DeadSet.new.clear

        # Clear 'Processed' and 'Failed' jobs statistics

        Sidekiq::Stats.new.reset
    end
        # admin_backup_dbs.each do |db_job|
        #     de_date = get_delete_date(db_job.destroy_schedule, db_job.delete_date)
        #     if Sidekiq::ScheduledSet.new.find_job(db_job.backup_job_id).nil?
        #         backup_job = BackupDbJob.set(:wait_until =>get_backup_scheduletime(db_job.backup_schedule)).perform_later(get_backup_scheduletime(db_job.backup_schedule), db_job.file_type,db_job.id)

        #         db_job.update_columns(backup_job_id: backup_job.provider_job_id)
        #     end
        #     if Sidekiq::ScheduledSet.new.find_job(db_job.delete_job_id).nil?
        #         destory_job = DeleteBackupJob.set(:wait_until =>get_destory_scheduletime(db_job.destroy_schedule)).perform_later(db_job.id)
        #         db_job.update_columns(delete_date: de_date,delete_job_id: destory_job.provider_job_id )
        #     end
            
        # end

    # end 

    if ENV.fetch("RAILS_ENV", "development") == "development"
        Sidekiq::Queue.all.each {|x| x.clear}

        # Clear retry set

        Sidekiq::RetrySet.new.clear

        # Clear scheduled jobs 

        Sidekiq::ScheduledSet.new.clear

        # Clear 'Dead' jobs statistics

        Sidekiq::DeadSet.new.clear

        # Clear 'Processed' and 'Failed' jobs statistics

        Sidekiq::Stats.new.reset
    end
end