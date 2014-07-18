require 'spec_helper'

	feature "Page headings should have 'Roles' in it" do
		
		before(:each) do
			@project_module = FactoryGirl.create(:project_module)
			@company = FactoryGirl.create(:company)
			sign_in
		end
			
		scenario "Edit Project Module page should have the right content" do
			visit edit_project_module_projects_path(@project_module.id) 
		  	expect(page).to have_title("Edit")
		end
		
		scenario "is valid with title and body(content)" do
		    @project_module.should be_valid
		end
				
		scenario "is not valid with an empty role name" do
		    project_module = FactoryGirl.build(:project_module, name:nil)
		    project_module.should_not be_valid
		end
		
		# scenario "allows the user to create new role" do
# 			visit project_module_projects_path
# 			fill_in "Module Name", with: "NewModule"
# 			click_button "Save"
# 			expect(page).to have_content("Project Module was successfully created")
# 		end
	end
