class UserMailer < ActionMailer::Base
 default from: 'notifications@example.com'
 
  def welcome_email(user_info)
 	email = user_info[:email]
    #email = "manali.khoat@cuelogic.co.in"
	@username = user_info[:username]
    @link =  user_info[:link]
    @url  = user_info[:url]
	mail(to: email, subject: 'Welcome to Magnifi.it')
  end
  
  def delayed_reason(user_info)
     @user_info = user_info
     email = "kalyani.bagale@cuelogic.co.in"
	 #email = user_info[:email]
  	 mail(to: email, subject: 'Reason for changing Milestone')
  end
  
  def raise_invoice(user_info)
     @user_info = user_info
	 email = "kalyani.bagale@cuelogic.co.in"
	 #email = user_info[:email]
     mail(to: email, subject: 'Raise Invoice for the project:'+user_info[:project_name])
  end
  def forgot_password_email(user_info)
  	email = user_info[:email]
	@username = user_info[:username]
    @link =  user_info[:link]
    @url  = user_info[:url]
    mail(to: email, subject: 'Forgot password for Magnifi.it')
  end
  
  def project_invite_email(proj_info)
  email = proj_info[:email]
	#email = "manali.khoat@cuelogic.co.in"
	#email = "kalyani.bagale@cuelogic.co.in"
	@proj_name = proj_info[:proj_name]
    @url  = proj_info[:url]
    mail(to: email, subject: 'Invitation for project '+@proj_name )
  end
  
  def project_created(proj_info)
  	#email = proj_info[:email]
	email = "manali.khoat@cuelogic.co.in"
	#email = "kalyani.bagale@cuelogic.co.in"
	@proj_name = proj_info[:proj_name]
    @url  = proj_info[:url]
    mail(to: email, subject: 'Project Incharge for '+@proj_name )
  end

end


 