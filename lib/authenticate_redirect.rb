class AuthenticateRedirect < Devise::FailureApp
    def redirect_url
      if scope == :admin
        new_admin_session_url()
      else
        new_user_session_url()
      end
     
   end

   # You need to override respond to eliminate recall
   def respond
     if http_auth?
       http_auth
     else
       redirect
     end
   end
  end