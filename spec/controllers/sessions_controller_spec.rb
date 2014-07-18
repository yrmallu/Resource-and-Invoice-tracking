require 'spec_helper'

describe SessionsController do
  before {@user = FactoryGirl.create(:user)}
  
  describe "#new" do
    before {get :new}
    it "has a status code of 200" do
      expect(response.code).to eq("200")
    end
    it "renders the new template" do
      expect(:response).to render_template("new")
    end
  end
  describe "#create" do
    context "with valid information" do
      before do
        session={email: "valid@gmail.com",:password=>"ammananna"}
        post :create, :session=>session
      end    
      it "loads valid user into user" do
        expect(assigns[:user]).to eq(@user)
        #response.should redirect_to(root_path)
      end
      it "redirects to the root_path" do
       expect(:response).to redirect_to(root_path)
      end
    end  
      context "with invalid information" do
        it "renders new template" do
          session={email: "valid@gmail.com",:password=>"ammananna11"}
          post :create, :session=>session
          expect(:response).to redirect_to(signin_path)
        end
      end  
  end
end
