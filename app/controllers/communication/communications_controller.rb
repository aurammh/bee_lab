class Communication::CommunicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_communication_communication, only: %i[ show edit update destroy conversation_forum ]
  include CommonHelper
  # GET /communication/communications or /communication/communications.json
  def index
    @all_conversation_list = (Communication::Communication.new.get_conversation_details_list(current_user.id) | Communication::Communication.new.get_conversation_list(current_user.id)).sort_by(&:created_at).reverse
    @all_conversation_list = Kaminari.paginate_array(@all_conversation_list).page(params[:page]).per(12)
    #get conversation count 
    @conversationDetailListCount = Communication::CommunicationDetail.all.group('communication_id').count
    #to check read or not conversation
    new_communication_array
  end

  # GET /communication/communications/1 or /communication/communications/1.json
  def show
  end

  # GET /communication/communications/new
  def new
    @communication_communication = Communication::Communication.new
    if current_user.user_type == 1 
      studentInfo = Student::Student.find_by(:id => params[:id])
      @receiver_id = studentInfo.user_id
    else
      companyInfo = Company::Company.find_by(:id => params[:id])
      @receiver_id = companyInfo.user_id
    end
    @receiverMail = User.find(@receiver_id).email
    @category_name = params[:name]

    respond_to do |format|
      format.js {render 'communication/communications/show_modal'}
      format.json { render json: @communication_communication.errors}
    end
  end

  # GET /communication/communications/1/edit
  def edit
  end

  # POST /communication/communications or /communication/communications.json
  def create
    @communication_communication = Communication::Communication.new(communication_communication_params)
    respond_to do |format|
      if @communication_communication.save
        # save into notification table
        notifications = Communication::Notification.new(:record_type=>"message_sent", :record_id=>@communication_communication.id,:sender_id=>current_user.id,:receiver_id => @communication_communication.receiver_id)
        notifications.save

        #get receiver name and email for mailer
        receiver_name = get_speaker_name(@communication_communication.receiver_id)
        receiver_email = User.find(@communication_communication.receiver_id).email
        if current_user.user_type == 2
          # get notificatin count by communication_id and receiver_id
          notiCount = Communication::Notification.where("receiver_id = ?", @communication_communication.receiver_id).count
          #get mail_setting from company table
          mail_setting = Company::Company.find_by(:user_id => @communication_communication.receiver_id).mail_setting
          unless mail_setting == 0
            if mail_setting == 1
              Communication::CommunicationMailer.with(receiver_name: receiver_name, receiver_email: receiver_email).communication_email.deliver_now
            elsif notiCount >= mail_setting && notiCount % mail_setting == 0
              Communication::CommunicationMailer.with(receiver_name: receiver_name, receiver_email: receiver_email).communication_email.deliver_now
              end 
          end
          # page render by sent message pages
          if params[:communication_communication][:category] == "Company"
            format.html { redirect_to student_path(params[:communication_communication][:forum_id])}
          elsif  params[:communication_communication][:category] == "Event"
            format.html { redirect_to student_event_details_path(params[:communication_communication][:forum_id])}
          else
            format.html { redirect_to company_vacancy_path(params[:communication_communication][:forum_id])}
          end
          
        else
          Communication::CommunicationMailer.with(receiver_name: receiver_name, receiver_email: receiver_email).communication_email.deliver_now
          format.html { redirect_to company_student_details_path(params[:communication_communication][:forum_id])}
        end        
      else
        format.html { render :new }
        format.json { render json: @communication_communication.errors}
      end
    end
  end

  # PATCH/PUT /communication/communications/1 or /communication/communications/1.json
  def update
    respond_to do |format|
      if @communication_communication.update(communication_communication_params)
        format.html { redirect_to @communication_communication, notice: "Communication was successfully updated." }
        format.json { render :show, status: :ok, location: @communication_communication }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @communication_communication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /communication/communications/1 or /communication/communications/1.json
  def destroy
    @communication_communication.destroy
    respond_to do |format|
      format.html { redirect_to communication_communications_url, notice: "Communication was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def conversation_forum
    @conversation_detail_list = Communication::CommunicationDetail.where(:communication_id => params[:id]).order(:created_at).to_a
    readNotification = Communication::Notification.where("record_id = ? AND receiver_id = ?",params[:id],current_user.id ).destroy_all
    render "communication/communications/list/conversation_form"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_communication_communication
      @communication_communication = Communication::Communication.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def communication_communication_params
      params.require(:communication_communication).permit(:title, :category,:sender_id, :receiver_id, :content)
      
    end
end
