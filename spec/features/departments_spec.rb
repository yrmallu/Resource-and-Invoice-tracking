require 'spec_helper'

feature "Page headings should have 'Department' in it" do
	
	before(:each) do
		@company = FactoryGirl.create(:company)
		@department = FactoryGirl.create(:department)
		sign_in
	end	
	
	scenario "Listing/Index Department page should have title 'Departments'" do
    	visit departments_path
    	expect(page).to have_title("Listing Departments")
	end
	
	scenario "Edit Department page should have the right title" do
		visit edit_department_path(@department.id) 
	  	expect(page).to have_title("Edit Department")
	end
	
	scenario "Create Department page should have the right title" do
		visit new_department_path
	  	expect(page).to have_title("New Department")
	end
	
	it "is valid with title and body" do
	    @department.should be_valid
	end
  
	it "is not valid with an empty title" do
	    department = FactoryGirl.build(:department, name:nil)
	    department.should_not be_valid
	end
	  
	scenario "allows the user to create new department" do
		visit "/departments/new"
		fill_in "Department Name", with: "DepartmentName"
		click_button "Create"
		#save_and_open_page
		expect(page).to have_content("Department was successfully created.")
	end
	
	scenario "allows the user to edit department" do
		visit edit_department_path(@department.id)
		fill_in "Department Name", with: "NewDepartment"
		click_button "Update"
		expect(page).to have_content("Department Details Updated")
	end

end


