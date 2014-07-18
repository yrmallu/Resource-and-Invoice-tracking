require 'spec_helper'

describe ClientsController do

	let(:user){FactoryGirl.create(:user,:company=>@company, :is_admin=>true)}

  def mock_client(stubs={})
    (@mock_client ||= mock_model(Client).as_null_object).tap do |client|
      client.stub(stubs) unless stubs.empty?
    end 
  end
  before do
    controller.should_receive(:logged_in?)
    @company = FactoryGirl.create(:company)
  end
  describe "GET #show" do
    let(:client) {FactoryGirl.create(:client)}
    before do
		current_user!(user)
		get :show, :id=>client.to_param
	end
    it "loads the requested client into @client" do
      expect(assigns[:client]).to eq(client)
    end
    it "renders the show template" do
      expect(response).to render_template("show")
    end 
  end
  
  describe "POST #create" do
    let(:client){FactoryGirl.attributes_for(:client,:address_attributes=>{:city=>"Podili",:photos=>('app/assets/images/useraccountsicon.png')})}
    context "with valid attributes" do
      it "creates a new client" do
        expect {post :create, :client=>client}.to change(Client, :count).by(1)
      end
      it "creates new address of the related client" do
       expect {post :create, :client=>client}.to change(Address, :count).by(1)
      end
      it "redirects to show page" do
        post :create, :client=>client
        expect(:response).to redirect_to Client.last
      end
    end
    context "with invalid attributes" do
      let(:invalid_client){FactoryGirl.attributes_for(:client,:name=>"")}
      it "does not create a new client" do
        expect {post :create, :client=>invalid_client}.not_to change(Client,:count).by(1)
      end
      it "renders the new page" do
       post :create, :client=>invalid_client
       expect(:response).to render_template("new")
      end
    end
  end
    
  # describe "PUT #update" do
  #     before do
  #       @client = FactoryGirl.create(:client)
  #       @address = FactoryGirl.create(:address,:client=>@client)
  #       #controller.request.should_receive(:referrer).and_return('http://example.com')
  #     end  
  #     context "with valid attributes" do
  #       let(:client_param){FactoryGirl.attributes_for(:client,:name=>"Amma Nanna",:address_attributes=>{:city=>"Medak"})}
  #       before {put :update, :id=>@client.to_param, :client=>client_param}
  #       it "located the request at @client" do
  #         expect(assigns[:client]).to eq(@client) 
  #       end
  #       it "changes @client's attributes" do
  #         @client.reload
  #         #@client.address.reload
  #         expect(@client.name).to eq("Amma Nanna")
  #         expect(@client.address.city).to eq("Medak")
  #       end
  #       it "redirects to the updated client" do
  #         expect(:response).to redirect_to @client
  #       end
  #     end
  #     context "with invalid attributes" do
  #       let(:client_invalid_param){FactoryGirl.attributes_for(:client,:name=>"",:address_attributes=>{:city=>"Medak"})}
  #       before {put :update, :id=>@client.to_param, :client=>client_invalid_param}
  #       it "does not change the @client's attributes" do
  #         @client.reload
  #         expect(@client.name).to eq("MyString")
  #         expect(@client.name).to eq("MyString")
  #       end
  #       it "renders the edit page" do
  #         expect(:response).to render_template("edit")
  #       end     
  #     end
  # end
  
  describe "GET #index" do
    before do 
		current_user!(user)
      #controller.should_receive(:set_company)
      #controller.should_receive(:set_company)
      #controller.should_receive(:get_client)
      get :index
    end  
    it "has a status code of 200" do
      expect(response.code).to eq("200")
    end
    it "renders the index page template" do
      expect(:response).to render_template("index")
    end
    it "loads all clients of a company into @clients" do
      client1,client2 = FactoryGirl.create(:client),FactoryGirl.create(:client)
      expect(assigns[:clients]).to match_array([client1,client2])
    end
  end
  
  describe "GET #new" do
  	before do
		current_user!(user)
	end
    it "assigns new client into @client" do
      Client.stub(:new) {mock_client}
      get :new
      assigns(:client).should eq(mock_client)
    end
    # before{@client = FactoryGirl.build(:client,:company_id=>nil,:website=>nil,:description=>nil,:name=>nil)}
    # xit "creates a new client into @client" do
    #   get :new
    #   expect(assigns[:client]).to eq(@client)
    # end
  end
  
  describe "DELETE #destroy" do
    let(:client){FactoryGirl.create(:client)}
    before {delete :destroy, :id=>client.to_param}
    it "sets delete_flag to true" do
      client.reload
      expect(client.delete_flag).to eq(true)
    end
    it "redirects to the index page" do
      expect(:response).to redirect_to clients_path
    end
  end
  
  describe "GET #add_contact_point" do
    let(:client){FactoryGirl.create(:client)}
    before do
		current_user!(user)
      @contact_point = FactoryGirl.build(:user, :client=>client)
      get :add_contact_point, :id=>client.to_param
    end
    it "builds new contact point of a client" do
      assigns(:contact_point) == (@contact_point)
      #expect(assigns[:contact_point]).to eq(@contact_point)
    end
  end
  
  describe "GET #contact_detail" do
    before do 
		current_user!(user)
		@client = FactoryGirl.create(:client)
	end
    it "loads all contact points of a client" do
      cont_point1,cont_point2 = FactoryGirl.create(:user,:email=>"reddy@gmail.com",:client=>@client),FactoryGirl.create(:user, :email=> "yr123@gmail.com",:client=>@client)
      get :contact_detail,:id=>@client.id
      expect(assigns[:contact_points]).to match_array([cont_point1,cont_point2])
    end
  end
end
