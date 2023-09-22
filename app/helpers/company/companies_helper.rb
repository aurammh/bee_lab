module Company::CompaniesHelper
    def mail_setting_options
        Company::Company.mail_settings.map{|k,v| [t("mail_setting.#{k}"),v]}
    end
end