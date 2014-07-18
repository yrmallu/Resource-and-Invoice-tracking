require 'spec_helper'

feature "Forgot Password" do

	 	 scenario "GET /forgot_password template" do
	    	get forgot_password_path
	      	response.status.should be(200)
	  	 end
		 
		 scenario "email cannot be nil for forgot password form" do
 		   	@user = FactoryGirl.create(:user)
 		   	visit signin_path
			click_link "Forgot password"
			fill_in "email", :with => @user.email
 		   	click_button "Forgot password"
			page.should have_content("Email sent with password reset instructions")
			last_email.to.should include(@user.email)
 		end
		
end

