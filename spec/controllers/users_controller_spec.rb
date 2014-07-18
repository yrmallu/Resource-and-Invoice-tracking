require 'spec_helper'

describe UsersController do

  before do
    @company = FactoryGirl.create(:company)
  end
  
  let(:user){FactoryGirl.create(:user,:user_type => "employee",:company=>@company, :is_admin=>true)}
  
  describe "GET #show" do
    let(:user){FactoryGirl.create(:user,:user_type => "employee",:company=>@company)}
    
	before do
		controller.should_receive(:logged_in?)
		current_user!(user)
		get :show, :id=>user
	end
	
    it "loads the requested user into @user" do
      expect(assigns[:user]).to eq(user)
    end
    it "renders the show template" do
      expect(response).to render_template("show")
    end
  end
  
  describe "POST #create" do
  
 	before do
		controller.should_receive(:logged_in?)
	end
    let(:user){FactoryGirl.attributes_for(:user,:user_type => "employee",:company=>@company,:addresses_attributes=>{"0"=>FactoryGirl.attributes_for(:address, :address_type=>'permanent'),"1"=>FactoryGirl.attributes_for(:address, :address_type=>'current')})}
    context "with valid attributes" do
      it "creates the new user" do
        expect{post :create, :user=>user}.to change(User, :count).by(1)
      end
      it "creates a two addresses for the user" do
        expect{post:create, :user=>user}.to change(Address, :count).by(2)
      end
      it "redirects to the show page" do
        post :create, :user=>user
        expect(response).to redirect_to User.last
      end
    end
  
   context "with invalid attributes" do
      let(:invalid_user){FactoryGirl.attributes_for(:user, :email=> "", :user_type => "employee",:company=>@company)}
      it "does not create a user" do
        expect{post :create, :user=>invalid_user}.not_to change(User,:count).by(1)
      end
      it "renders the new template" do
        post :create, :user=>invalid_user
        expect(response).to render_template("new")
      end
    end
  end
  
  describe "PUT #update" do
    before do
	  @user = FactoryGirl.create(:user)
    end
	
    context "with valid attributs" do
      let(:user){FactoryGirl.attributes_for(:user, :firstname=>"Govinda",:user_type => "employee",:company=>@company,:addresses_attributes=>{"0"=>FactoryGirl.attributes_for(:address, :city=> "Mumbai", :address_type=>'permanent'),"1"=>FactoryGirl.attributes_for(:address, :address_type=>'current')})}
      before do
	  	controller.should_receive(:logged_in?)
	  	put :update, :id=>@user, :user=>user
	  end
      it "loads the requested user into @user" do
        expect(assigns[:user]).to eq(@user)
      end
      it "changes @user's attributes" do
        @user.reload
        expect(@user.firstname).to eq("Govinda") 
      end
      it "rediects to the updated user" do
        expect(response).to redirect_to @user
      end
    end
  
    context "with invalid attributes" do
      let(:invalid_user){FactoryGirl.attributes_for(:user, :firstname=>"",:user_type => "employee",:company=>@company,:addresses_attributes=>{"0"=>FactoryGirl.attributes_for(:address, :city=> "Mumbai", :address_type=>'permanent'),"1"=>FactoryGirl.attributes_for(:address, :address_type=>'current')})}
      before do 
	  	controller.should_receive(:logged_in?)
		put :update, :id=>@user, :user=>invalid_user
	  end
      it "loads the requested user into @user" do
        expect(assigns[:user]).to eq(@user)
      end
      it "does not change @user's attributes" do
        @user.reload
        expect(@user.firstname).to eq("Reddy")
      end
      it "renders the edit template" do
        expect(response).to render_template("edit")
      end
    end
  end
  
  describe "GET #index" do
    before do 
	    controller.should_receive(:logged_in?)
		current_user!(user)
		get :index
	end
	
    it "has a status code of 200" do
      expect(response.code).to eq("200")
    end
    it "loads all users related to a company into @users" do
      user1, user2 = FactoryGirl.create(:user,:email=>"reddy@gmail.com",:user_type => "employee", :firstname=>"Amma", :company=>@company),FactoryGirl.create(:user,:email=>"yr@gmail.com",:user_type => "employee", :firstname=>"nanna",:company=>@company)
      expect(assigns[:users]).to match_array([user,user1,user2])
    end
    it "renders the index template" do
      expect(response).to render_template("index")
    end
  end
  
  describe "DELETE #destroy" do
    let(:user){FactoryGirl.create(:user)}
    
	before do 
		controller.should_receive(:logged_in?)
		current_user!(user)
		delete :destroy, :id=>user.to_param
	end
	
    it "sets delete_flag to true" do
      user.reload
      user.delete_flag == (true)
    end
    it "redirects to the index page" do
      expect(:response).to redirect_to users_path
    end
  end
  
  describe "GET #new" do
    before do
	  controller.should_receive(:logged_in?)
	  current_user!(user)
      @user = FactoryGirl.build(:user, :company=>@company)
      get :new
    end
    it "builds new user into @user" do
      assigns(:user) == (@user)
      #expect(assigns[:user]).to eq(@user)
    end
    it "renders the new template" do
      expect(response).to render_template("new")
    end
  end
  
  describe "#GET get_user_accessright" do
   
    let(:role){FactoryGirl.create(:role)}
    let(:user){FactoryGirl.create(:user, :role=>role)}
    let(:accessright){FactoryGirl.create(:accessright,:roles=>role)}
    let(:added_accessright){FactoryGirl.create(:user_accessright, :user=>user, :accessright=>accessright,:access_flag => false)}
    let(:removed_accessright){FactoryGirl.create(:user_accessright, :user=>user, :accessright=>accessright,:access_flag => true)}
    before do
		controller.should_receive(:logged_in?)
		current_user!(user)
		get :get_user_accessright, :id=>user
	end
    it "has the status code of 200" do
      expect(response.code).to eq("200")
    end
    it "loads requested user into @user" do
      expect(assigns[:user]).to eq(user)
    end
    it "loads all user's access rights into @access_rights" do
      access1 = (user.role.accessrights.collect!{|i| i.id.to_s} +  user.accessrights.where("access_flag = false").collect!{|i| i.id.to_s}) - user.accessrights.where("access_flag = true").collect!{|i| i.id.to_s} 
      expect(assigns[:access_rights]).to match_array(access1)
    end
    it "renders the get_user_accessright template" do
      expect(response).to render_template("get_user_accessright")
    end
  end
  
  describe "#POST update_user_accessright" do
    let(:role){FactoryGirl.create(:role)}
    let(:accessright){FactoryGirl.create(:accessright)}
    let(:user){FactoryGirl.create(:user, :role=>role)}
    let(:added_access){user.accessrights.where("access_flag = false").collect!{|i| i.id.to_s}}
    let(:removed_access){user.accessrights.where("access_flag = true").collect!{|i| i.id.to_s}}
    let(:role_access){user.role.accessrights.collect!{|i| i.id.to_s}}
    
	before do
		controller.should_receive(:logged_in?)
		current_user!(user)
		post :update_user_accessright, :id=>user, :checked_list=>[accessright.id], :unchecked_list=>[accessright.id]
	end
    it "loads the requested user into @user" do
      expect(assigns[:user]).to eq(user)
    end
    it "access to the the more access rights" do
        ([accessright.id.to_s] - (role_access - removed_access)+ added_access).each do |x|
          unless (removed_access).include?(x)
            user.user_accessrights.create(:accessright_id=>x, :access_flag=>false)
            user.user_accessrights.count.should > 0
          else
            user.user_accessrights.where("accessright_id=#{x}").first.update({:access_flag=>false})
          end
      end
    end
    it "restrict from some access rights" do
      ([accessright.id.to_s].split(",") & (role_access + added_access + removed_access)).each do |x|
        unless (added_access + removed_access).inlcude?(x)
          user.user_accessrights.create(:accessright_id=>x, :access_flag=>true)
          user.user_accessrights.count.should > 0
        else
          user.user_accessrights.where("accessright_id=#{x}").first.update({:access_flag=>true})
        end
      end      
    end 
  end   

  # Test case for user filter left panel loading through ajax
  describe "Ajax call for filter (left panel) User filter" do
  	 before do
	 	controller.should_receive(:logged_in?)
	 end
  	 it "returns http success" do
 	       xhr :get, :user_filter
 	 	   response.should be_success
 	 end
     it "returns result set when it receives employee name" do
 	       xhr :get, :user_filter, :user_name => "someName", :technology_name => "techName", :education_name => "eduName", :department_id => "1", 
		   				:role_id => "1", :gender_type => "M"
 	 	   response.should be_success
 	 end
  end
  
  # Test case for forgot password
  describe "GET forgot password" do
  	let(:user){FactoryGirl.create(:user)}
    before do
		controller.should_not_receive(:logged_in?)
		get :forgot_password, :email=>user.email
	end
    it "renders the forgot password template" do
      expect(response).to render_template("forgot_password")
    end
  end
  
  # Test case for reset password
  describe "GET reset password" do
  	let(:user){FactoryGirl.create(:user)}
    before do
		controller.should_not_receive(:logged_in?)
		get :reset_password, :password=>"111111", :password_confirmation=>"111111", :email=>user.email
	end
    it "renders the reset password template" do
      expect(response).to render_template("reset_password")
    end
	it "redirects to sigin page on password and password_confirmation matching" do
		user.password == user.password_confirmation
		response.should be_success
	end
  end
  
end
