require 'spec_helper'

feature "New Project" do
  
  before do 
    @company = FactoryGirl.create(:company)
    @client = FactoryGirl.create(:client, :company=>@company)
    @project = FactoryGirl.build(:project,:client=>@client, :company=>@company)
    sign_in
  end  
  
  scenario "name without nil" do
    visit new_project_path
    fill_in "Title", :with=>@project.title
    page.select @client.name, :from => "Client"
    #fill_in "Client", :with=>@client.name
    # fill_in "Description", :with=>@client.description
    # fill_in "Street", :with=>@address.street
    click_button "Save"
    expect(page).to have_content("Project was successfully created.")
  end
   
end