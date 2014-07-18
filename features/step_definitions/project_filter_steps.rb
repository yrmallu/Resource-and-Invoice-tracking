
Given(/^a User is signed in and visits the project index page$/) do
	sign_in
	visit projects_path
end

Then(/^project_filter partial has select box$/) do
	page.select "Select Client", :from => "client_id"
	page.select "Select Project Type", :from => "proj_type"
end

Then(/^user see a _project_filter partial$/) do
  page.has_content?('Search Criteria')
  page.has_content?('Project Name')
  page.has_content?('Project Type')
  page.has_content?('Client')
end

Then(/^press Search button$/) do
  click_button('Search')
end

Then(/^user see results in main content$/) do
  page.has_content?('Actions')
  page.has_content?('Name')
  page.has_content?('Client')
  page.has_content?('Project Manager')
  page.has_content?('Start Date')
  page.has_content?('End Date')
end

