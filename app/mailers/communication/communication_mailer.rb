class Communication::CommunicationMailer < ApplicationMailer
    layout 'layouts/communication/mailer'
    default from: 'info@beelab-recruit.com'
    
    def communication_email
        @receiver_email = params[:receiver_email]
        @receiver_name = params[:receiver_name]
        mail(to: @receiver_email, subject: 'コミュニケーション通知')
    end
end
