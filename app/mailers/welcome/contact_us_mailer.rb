class Welcome::ContactUsMailer < ApplicationMailer
    layout 'layouts/mailer/mailer'

    default to: -> {'y.jintoku@steams-jp.com,r.takeyoshi@steams-jp.com,n.chiba@steams-jp.com,k.komatsu@fieldofdreams-jp.com'},
          from: 'info@beelab-recruit.com'
    def contact_email
        @contact_us = params[:contact]
        mail(subject: 'お問い合わせメール')
    end

end