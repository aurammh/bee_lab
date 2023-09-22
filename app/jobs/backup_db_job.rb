class BackupDbJob < ApplicationJob
  queue_as :default

  def perform(backUp_sch,file_type,id)
  # Do something later

    host = ActiveRecord::Base.connection_db_config.configuration_hash[:host]
    database = ActiveRecord::Base.connection_db_config.configuration_hash[:database]
    username = ActiveRecord::Base.connection_db_config.configuration_hash[:username]
    password = ActiveRecord::Base.connection_db_config.configuration_hash[:password]
    port = ActiveRecord::Base.connection_db_config.configuration_hash[:port]
    f_name = "#{Rails.root}/db/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{database}#{file_type}"
    cmd = "PGPASSWORD='#{password}' pg_dump -F c -v -h '#{host}' -p '#{port}'  -U '#{username}' -f '#{f_name}' #{database}"
    system cmd

    # insert into backup_detail and active storage by BACKUP_SHEDULE_TIME
    backup_data = Admin::BackupDetail.new
    backup_data.backup_dbs_id = id
    backup_data.save    
    backup_data.file_type.attach(io: File.open(f_name), filename: f_name.rpartition("/").last)
    File.delete("#{Rails.root}/db/#{f_name.rpartition("/").last}") 
    admin_backup_db = Admin::BackupDb.find(id)
    # job = self.class.set(:wait => backUp_sch).perform_later(backUp_sch,file_type,id)
    job = self.class.set(:wait_until =>get_backup_scheduletime(admin_backup_db.backup_schedule)).perform_later(get_backup_scheduletime(admin_backup_db.backup_schedule),file_type,id)
    admin_backup_db.update_columns(backup_job_id: job.provider_job_id)
  end
end