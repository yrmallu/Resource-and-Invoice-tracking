module Features
  module SessionHelpers
  
    def sign_up_with(options)
      visit signout_path  
      fill_in 'Email', :with=>options[:email]
      fill_in 'Password', :with=>options[:password]
      fill_in 'Password confirmation', :with=>options[:password_confirmation]
      fill_in 'First name', :with=>options[:first_name]
      click_button 'Sign up'
    end
   
    def sign_in
      user =  FactoryGirl.create(:user)
      visit signin_path
	  #save_and_open_page
      fill_in 'Email', :with=>user.email
      fill_in 'Password', :with=>user.password
	  
      click_button 'Sign in'
    end
  
  end
end