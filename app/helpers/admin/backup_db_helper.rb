module Admin::BackupDbHelper
  #Database backup shedule options
  def backup_options
    Admin::BackupDb.backup_shedules.map{ |k,v| [t("backup_db.backup_schedule_options.#{v}"), v] }
  end

  #Database backup shedule options
  def destroy_options
    Admin::BackupDb.destroy_shedules.map{ |k,v| [t("backup_db.destroy_schedule_options.#{v}"), v] }
  end

  #to get destory_shedule time
  def get_backup_scheduletime(bk_time)
    sch_time = Time.zone.now
    if (bk_time.to_i == 1)
        sch_time = Time.zone.today.end_of_day
    elsif (bk_time.to_i == 2)
      sch_time = Time.now.end_of_week
    else
      sch_time = Time.now.end_of_month
    end
    return sch_time
  end

  #to get backup_shedule time
  def get_destory_scheduletime(bk_time)
    sch_time = Time.zone.now
    if (bk_time.to_i == 1)
        sch_time = sch_time.end_of_week
    elsif (bk_time.to_i == 2)
      sch_time = sch_time.end_of_month
    else
      sch_time = (sch_time + 2.months).end_of_month
    end
    return sch_time
  end

  #get to run delete schedule time for next
  def get_delete_date(destory_mode,delete_date)
    sch_time = delete_date
    current_date = Date.today
    if (destory_mode.to_i == 1)
        sch_time = (current_date.at_beginning_of_week.to_s) == (sch_time.at_beginning_of_week.to_s) ?  sch_time.at_beginning_of_week :  sch_time.next_week
    elsif (destory_mode.to_i == 2)
      sch_time = (current_date.at_beginning_of_month.to_s) == (sch_time.at_beginning_of_month.to_s) ? sch_time.at_beginning_of_month : sch_time.next_month
    else
      sch_time = (current_date - 2.months).at_beginning_of_month
    end
    return sch_time
  end

  #get date range for search
  def date_range_split_from_flatpickr(_date_params)
    if _date_params.include? ' to '
      _date_params.split(' to ', 0)
    else
      [_date_params,_date_params]
    end
  end

  #change bytes to megabytes
  MEGABYTES = 1024.0 * 1024.0
  def bytes_to_megabytes (bytes)
      (bytes / MEGABYTES).round(2)
  end
end