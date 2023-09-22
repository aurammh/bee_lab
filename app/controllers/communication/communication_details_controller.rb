class Communication::CommunicationDetailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_communication_communication_detail, only: %i[ show edit update destroy ]
  include CommonHelper
  # GET /communication/communication_details or /communication/communication_details.json
  def index
    @communication_communication_details = Communication::CommunicationDetail.all
  end

  # GET /communication/communication_details/1 or /communication/communication_details/1.json
  def show
  end

  # GET /communication/communication_details/new
  def new
    @communication_communication_detail = Communication::CommunicationDetail.new
  end

  # GET /communication/communication_details/1/edit
  def edit
  end

  # POST /communication/communication_details or /communication/communication_details.json
  def create
    @communication_communication_detail = Communication::CommunicationDetail.new(communication_communication_detail_params)
    respond_to do |format|
      if @communication_communication_detail.save
        # save into notification table
        notifications = Communication::Notification.new(:record_type=>"message_reply", :record_id=>@communication_communication_detail.communication_id,:sender_id=>current_user.id,:receiver_id => @communication_communication_detail.receiver_id)
        notifications.save

        #get receiver name and email for mailer
        receiver_name = get_speaker_name(@communication_communication_detail.receiver_id)
        receiver_email = User.find(@communication_communication_detail.receiver_id).email
        # to check user_type
        if current_user.user_type == 2
          # get notificatin count by communication_id and receiver_id
          notiCount = Communication::Notification.where("receiver_id = ?", @communication_communication_detail.receiver_id).count
          #get mail_setting from company table
          mail_setting = Company::Company.find_by(:user_id => @communication_communication_detail.receiver_id).mail_setting
          unless mail_setting == 0
            if mail_setting == 1
              Communication::CommunicationMailer.with(receiver_name: receiver_name, receiver_email: receiver_email).communication_email.deliver_now
            elsif notiCount >= mail_setting && notiCount % mail_setting == 0
              Communication::CommunicationMailer.with(receiver_name: receiver_name, receiver_email: receiver_email).communication_email.deliver_now
              end 
          end
        else
          Communication::CommunicationMailer.with(receiver_name: receiver_name, receiver_email: receiver_email).communication_email.deliver_now
        end
        format.html { redirect_to communication_conversation_forum_path(:id => @communication_communication_detail.communication_id) }
      else  
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @communication_communication_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /communication/communication_details/1 or /communication/communication_details/1.json
  def update
    respond_to do |format|
      if @communication_communication_detail.update(communication_communication_detail_params)
        format.html { redirect_to @communication_communication_detail, notice: "Communication detail was successfully updated." }
        format.json { render :show, status: :ok, location: @communication_communication_detail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @communication_communication_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /communication/communication_details/1 or /communication/communication_details/1.json
  def destroy
    @communication_communication_detail.destroy
    respond_to do |format|
      format.html { redirect_to communication_communication_details_url, notice: "Communication detail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_communication_communication_detail
      @communication_communication_detail = Communication::CommunicationDetail.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def communication_communication_detail_params
      params.require(:communication_communication_detail).permit(:communication_id, :sender_id, :receiver_id, :content)
    end
end
