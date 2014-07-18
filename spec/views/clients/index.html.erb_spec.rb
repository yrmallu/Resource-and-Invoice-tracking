require 'spec_helper'

describe "clients/index" do

  let(:user){FactoryGirl.create(:user,:company=>@company, :is_admin=>true)}
  context "with all clients" do
    before do 
		controller.stub(:current_user).and_return(user)
        assign(:clients, Kaminari.paginate_array([
        FactoryGirl.create(:client,:name=>"jay"),
        FactoryGirl.create(:client,:name=>"babu"
        )
      ]).page(1))
    end
    it "display all clients" do
      render
      expect(rendered).to match /babu/
    end
  end

end