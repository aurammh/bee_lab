class Admin::BackupDbController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_backup_db, only: %i[ new show edit update destroy ]
  include Admin::BackupDbHelper
  layout 'layouts/template/admin'
  require "sidekiq/api"

  # GET /admin/backup_dbs or /admin/backup_dbs.json
  def index
    @admin_backup_dbs = Admin::BackupDb.all
    @admin_backup_db = Admin::BackupDb.new
  end

  # GET /admin/backup_dbs/1 or /admin/backup_dbs/1.json
  def show
    search_query = search_backup_details
    @backup_db_details = Admin::BackupDetail.search_backupdetail(search_query)
    @backup_db_details = Kaminari.paginate_array(@backup_db_details).page(params[:page]).per(12) 
    puts params[:from_to_date]
  end

  # GET /admin/backup_dbs/new
  def new
    @admin_backup_db = Admin::BackupDb.new
  end

  # GET /admin/backup_dbs/1/edit
  def edit
    @admin_backup_db = Admin::BackupDb.find(params[:id])
    @admin_backup_dbs = Admin::BackupDb.all
    render :index
  end

  # POST /admin/backup_dbs or /admin/backup_dbs.json
  def create
    @admin_backup_db = Admin::BackupDb.new(admin_backup_db_params)
    @admin_backup_dbs = Admin::BackupDb.all
    de_date = get_delete_date(@admin_backup_db.destroy_schedule,Date.today)
    
      respond_to do |format|
        if @admin_backup_db.save
          # backup_job = BackupDbJob.set(:wait => 10.minutes).perform_later(10.minutes, @admin_backup_db.file_type,@admin_backup_db.id)
          #JOBS Running
          backup_job = BackupDbJob.set(:wait_until =>get_backup_scheduletime(@admin_backup_db.backup_schedule)).perform_later(get_backup_scheduletime(@admin_backup_db.backup_schedule), @admin_backup_db.file_type,@admin_backup_db.id)

          destory_job = DeleteBackupJob.set(:wait_until =>get_destory_scheduletime(@admin_backup_db.destroy_schedule)).perform_later(@admin_backup_db.id)
          
          @admin_backup_db.update_columns(delete_date: de_date,backup_job_id: backup_job.provider_job_id, delete_job_id: destory_job.provider_job_id )


          @admin_backup_db = Admin::BackupDb.new
          format.html { render :index, notice: "Backup db was successfully created." }
          format.json { render :index, status: :created, location: @admin_backup_db }
        else
          format.html { render :index, status: :unprocessable_entity }
          format.json { render json: @admin_backup_db.errors, status: :unprocessable_entity }
        end
      end
  end

  # PATCH/PUT /admin/backup_dbs/1 or /admin/backup_dbs/1.json
  def update
    respond_to do |format|
      @admin_backup_dbs = Admin::BackupDb.all
      if @admin_backup_db.update(admin_backup_db_params)
        de_date = get_delete_date(@admin_backup_db.destroy_schedule,Date.today)
        Sidekiq::ScheduledSet.new.find_job(@admin_backup_db.backup_job_id).delete
        Sidekiq::ScheduledSet.new.find_job(@admin_backup_db.delete_job_id).delete

        backup_job = BackupDbJob.set(:wait_until =>get_backup_scheduletime(@admin_backup_db.backup_schedule)).perform_later(get_backup_scheduletime(@admin_backup_db.backup_schedule), @admin_backup_db.file_type,@admin_backup_db.id)
        # backup_job = BackupDbJob.set(:wait => 10.minutes).perform_later(10.minutes, @admin_backup_db.file_type,@admin_backup_db.id)

        destory_job = DeleteBackupJob.set(:wait_until =>get_destory_scheduletime(@admin_backup_db.destroy_schedule)).perform_later(@admin_backup_db.id)
          
        @admin_backup_db.update_columns(delete_date: de_date,backup_job_id: backup_job.provider_job_id, delete_job_id: destory_job.provider_job_id )

        @admin_backup_db = Admin::BackupDb.new
        format.html { render :index, notice: "Backup db was successfully updated." }
        format.json { render :index, status: :ok, location: @admin_backup_db }
      else
        @admin_backup_db = Admin::BackupDb.new
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @admin_backup_db.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/backup_dbs/1 or /admin/backup_dbs/1.json
  def destroy
    
    Sidekiq::ScheduledSet.new.find_job(@admin_backup_db.backup_job_id).delete unless  Sidekiq::ScheduledSet.new.find_job(@admin_backup_db.backup_job_id).nil?
    Sidekiq::ScheduledSet.new.find_job(@admin_backup_db.delete_job_id).delete unless Sidekiq::ScheduledSet.new.find_job(@admin_backup_db.delete_job_id).nil?
    backup_db_details = Admin::BackupDetail.where(backup_dbs_id: @admin_backup_db.id)
      if backup_db_details.present?
        backup_db_details.each do |backup| 
          if backup.file_type.attached?
            backup.file_type.purge
          end
          backup.destroy
        end
      end
    @admin_backup_db.destroy
    respond_to do |format|
      format.html { redirect_to admin_backup_db_index_path, notice: "Backup db was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_backup_db
      @admin_backup_db = Admin::BackupDb.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_backup_db_params
      params.require(:admin_backup_db).permit(:name, :backup_schedule, :destroy_schedule, :remark, :file_type,:backup_job_id,:delete_job_id)
    end

    # Search Params With Query Check
    def search_backup_details
      search_from_to,search_backup_id = ''

      search_backup_id = if params[:id].blank?
        params[:id] =
          ''
      else
        "backup_details.backup_dbs_id = #{params[:id]}"
      end

      search_from_to = if params[:from_to_date].blank?
        params[:from_to_date] =
          ''
      else
        two_date = date_range_split_from_flatpickr(params[:from_to_date])
        "backup_details.created_at between '#{two_date[0]} 00:00' and '#{two_date[1]} 23:59'"
      end
      [search_from_to,search_backup_id]
    end
end