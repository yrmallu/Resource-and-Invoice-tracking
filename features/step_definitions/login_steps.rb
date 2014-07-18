Given(/^a user visits the signin page$/) do
  visit new_session_path
end

When(/^she submits invalid signin information$/) do
  click_button "Sign in"
end

Then(/^she should see an error message$/) do
  expect(page).to have_content('Invalid email/password combination')
end

Given(/^the user has an account$/) do
  @user = FactoryGirl.create(:user)
end

When(/^the user submits valid signin information$/) do
  fill_in "Email", :with=>@user.email
  fill_in "Password", :with=>@user.password
  click_button "Sign in"
end

Then(/^she should see her profile page$/) do
  expect(page).to have_content(@user.firstname)
end

Then(/^she should see a signout link$/) do
  expect(page).to have_link('Sign out', href: signout_path)
end



# Given(/^when I visit the login page$/) do
#   visit new_session_path
# end
# 
# Given(/^enter a valid username and password$/) do
#   fill_in "Email", :with=>user.email
#   fill_in "Password", :with=>user.password
# end
# 
# When(/^I press the login button$/) do
#   click_button 'Sign in'
# end
# 
# Then(/^I should see a success message$/) do
#   expect(page).to have_content("success")
# end