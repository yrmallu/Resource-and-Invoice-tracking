require 'spec_helper'

describe ContactPointsController do

  let(:user){FactoryGirl.create(:user,:company=>@company, :is_admin=>true)}
  
  before do
  	current_user!(user)
    controller.should_receive(:logged_in?)
    @client = FactoryGirl.create(:client)
  end
  %w{show edit}.each do |action|
    describe "GET '#{action}'" do
      let(:user){FactoryGirl.create(:user,:client=>@client)}
      before{get :"#{action}", :id=>user.to_param}
      it "loads the requested contact point into @contact_point" do
        expect(assigns[:contact_point]).to eq(user)
      end
      it "renders the show template" do
        expect(response).to render_template("#{action}")
      end
    end
  end
end
