class Company::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company_event, only: %i[ show edit update destroy ]
  include CommonHelper
  # GET /company/events or /company/events.json
  def index
    @company_events = Company::Company.new.get_event_entry_list(current_user.company.id)
    @student_join_event = Company::Company.new.get_join_event_student_count(current_user.company.id)
    get_hash_value(@student_join_event)
    @company_events = Kaminari.paginate_array(@company_events).page(params[:page]).per(12)
  end

  # GET /company/events/1 or /company/events/1.json
  def show
  end

  # GET /company/events/new
  def new
    permission_url
    @company_event = Company::Event.new
  end

  # GET /company/events/1/edit
  def edit
  end

  # POST /company/events or /company/events.json
  def create
    @company_event = Company::Event.new(company_event_params)
    @company_event.company_id = current_user.company.id
    count=Company::Event.count+1
    @company_event.event_code = "#{(Date.today + 6).year % 100}-#{count.to_s.rjust(5, "0")}"

    respond_to do |format|
      if @company_event.save
        save_img
        format.html { redirect_to @company_event}
        format.json { render :show, status: :created, location: @company_event }
      else
        format.html { render :new}
        format.json { render json: @company_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company/events/1 or /company/events/1.json
  def update
    respond_to do |format|
      if @company_event.update(company_event_params)
        # To delete upload image
        if params[:company_event][:imageFlag] == "true"
          @company_event.event_image.purge
        end
        save_img
        format.html { redirect_to @company_event, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @company_event }
      else
        format.html { render :edit}
        format.json { render json: @company_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def save_img
    unless params[:company_event][:image_data].eql?"false"
      blob = convert_Base64_imgData(params[:company_event][:image_data])
      @company_event.event_image.attach(blob)
      params[:company_event][:image_data] = false
    end
  end
  # DELETE /company/events/1 or /company/events/1.json
  def destroy
    @company_event.destroy
    respond_to do |format|
      format.html { redirect_to company_events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def permission_url
      if @permission_list.include?(3)
        redirect_to company_companies_path
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_company_event
      @company_event = Company::Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_event_params
      params.require(:company_event).permit(:event_image,:event_code, :event_start_date, :event_end_date, :event_name, :venue,
      :post_start_date, :post_end_date, :application_deadline, :event_content, :category=> [])
    end
end
