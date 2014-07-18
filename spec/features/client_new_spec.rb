require 'spec_helper'

feature "New Client" do
  
  before do 
    @company = FactoryGirl.create(:company)
    @client = FactoryGirl.build(:client)
    @address = FactoryGirl.build(:address,:client=>@client)
    sign_in
  end  
  
  scenario "name without nil" do
    visit new_client_path
    fill_in "Name", :with=>@client.name
    fill_in "Website", :with=>@client.website
    fill_in "Description", :with=>@client.description
    fill_in "Street", :with=>@address.street
    click_button "Save"
    expect(page).to have_content("Client was successfully created.")
  end
end