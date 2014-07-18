require 'spec_helper'

	feature "Page headings should have 'Roles' in it" do
		
		before(:each) do
			@role = FactoryGirl.create(:role)
			@company = FactoryGirl.create(:company)
			sign_in
		end
			
		# scenario "Listing/Index Roles page should have content 'Roles'" do
# 			get '/roles'
# 			expect(response.body).to have_content("Roles")
# 		end
		
		scenario "Edit Role page should have the right content" do
			visit edit_role_path(@role.id) 
		  	expect(page).to have_title("Edit Role")
		end
		
		scenario "is valid with title and body(content)" do
		    @role.should be_valid
		end
				
		scenario "is not valid with an empty role name" do
		    role = FactoryGirl.build(:role, name:nil)
		    role.should_not be_valid
		end
		
		scenario "allows the user to create new role" do
			visit new_role_path
			fill_in "Role Name", with: "NewRole"
			click_button "Create"
			expect(page).to have_content("Role was successfully created")
		end
	end
