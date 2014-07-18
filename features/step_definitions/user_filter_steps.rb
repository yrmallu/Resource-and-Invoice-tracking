
Given(/^a User is signed in and visits the user index page$/) do
	sign_in
	visit users_path
end

When(/^clicked on Advanced Search link$/) do
	#save_and_open_page
	click_link('Advanced Search')
end

Then(/^user should see a partial in left panel$/) do
  #should render_template(:partial => '_user_filter')
  #render :template => "users/_user_filter.html"
  #render :partial => 'users/_user_filter.html'
  page.has_content?('Search Criteria')
  page.has_content?('Name')
  page.has_content?('Technology')
  page.has_content?('Education')
  page.has_content?('Department')
  page.has_content?('Role')
  page.has_content?('Gender')
  page.has_content?('Employee Age')
  page.has_content?('Joining Date Search')
end

# Then(/^Advanced Search link should not be visible$/) do
#   page.should_not have_content('Advanced Search')
# end

Then(/^user_filter partial should contain select box$/) do
	page.select "Select Department", :from => "department_id"
	page.select "Select Role", :from => "role_id"
	page.select "Select Gender", :from => "gender_type"
end

Then(/^clicked on Search button$/) do
  click_button('Search')
end

Then(/^user should see results in main content$/) do
  page.has_content?('Actions')
  page.has_content?('Name')
  page.has_content?('Email')
  page.has_content?('Technology')
  page.has_content?('Designation')
  page.has_content?('Experience')
end

Then(/^clicked on Cancel link$/) do
  click_link('Cancel')
end

Then(/^user should see Advanced Search link back$/) do
  page.should have_content('Advanced Search')
end





