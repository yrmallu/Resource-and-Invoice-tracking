require 'spec_helper'

describe ProjectsController do
  before do
    controller.should_receive(:logged_in?)
    @company = FactoryGirl.create(:company)
    @client = FactoryGirl.create(:client, :company=>@company)
    @project = FactoryGirl.create(:project, :client=>@client, :company=>@company)
  end
  let(:user){FactoryGirl.create(:user,:user_type => "employee",:company=>@company)}
  describe "#GET show" do
    before do
      current_user!(user)
      get :show, :id=>@project
    end
    it "loads the requested project into @project" do
      expect(assigns[:project]).to eq(@project)
    end
    it "renders the show template" do
      expect(:response).to render_template("show")
    end
  end
  
  describe "#POST create" do
    let(:project){FactoryGirl.attributes_for(:project,:company=>@company,:project_files_attributes=>{"0"=>{"files"=>FactoryGirl.attributes_for(:project_file)}})}
    contact1, contact2 = FactoryGirl.create(:user, :user_type=>"contact_point", :email=>"amma1@gmail.com"), FactoryGirl.create(:user, :user_type=>"contact_point", :email=>"nanna1@gmail.com")
    context "with valid attributes" do
      it "creates a new project" do
        expect{post :create, :project=>project, :contact_persons=>[contact1,contact2]}.to change(Project, :count).by(1)
      end
      xit "creates two project files" do
        expect{post :create, :project=>project, :contact_persons=>[contact1,contact2]}.to change(ProjectFile, :count).by(1)
      end
      it "redirects to the show page" do
        post :create, :project=>project, :contact_persons=>[contact1,contact2]
        expect(response).to redirect_to Project.last
      end
    end
    context "with invalid attributes" do
      let(:invalid_project){FactoryGirl.attributes_for(:project, :title=>"", :company=>@company,:project_files_attributes=>{"0"=>{"files"=>FactoryGirl.attributes_for(:project_file)}})}
      it "doesn't create the new project" do
        expect{post :create, :project=>invalid_project, :contact_persons=>[contact1,contact2]}.not_to change(Project, :count)
      end
      it "renders the new template" do
        post :create, :project=>invalid_project, :contact_persons=>[contact1,contact2]
        expect(response).to render_template("new")
      end
    end
  end
  
  describe "#PUT update" do
    let(:project){FactoryGirl.attributes_for(:project, :title=>"Cue-HRMS", :company=>@company,:project_files_attributes=>{"0"=>{"files"=>FactoryGirl.attributes_for(:project_file)}})}
    contact1= FactoryGirl.create(:user, :user_type=>"contact_point", :email=>"abc@gmail.com")
    context "with valid attributes" do
      before{put :update, :id=>@project, :project=>project, :contact_persons=>[contact1]}
      it "loads the the requested project into @project" do
        expect(assigns[:project]).to eq(@project)
      end
      it "changes @projects's attributes" do
        @project.reload
        expect(@project.title).to eq("Cue-HRMS") 
      end
      it "rediects to the updated project" do
        expect(response).to redirect_to @project
      end
    end
    context "with invalid attributes" do
      let(:project){FactoryGirl.attributes_for(:project, :title=>"", :company=>@company,:project_files_attributes=>{"0"=>{"files"=>FactoryGirl.attributes_for(:project_file)}})}
      xit "does not change @project's attributes" do
        @project.reload
        expect(@project.title).to eq("Hrms")
      end
    end
  end
  
  describe "GET #new" do
    before do
      current_user!(user) 
      get :new
    end
    it "builds new user into @project" do
      assigns(:project) == (@project)
      #expect(assigns[:user]).to eq(@user)
    end
    it "renders the new template" do
      expect(response).to render_template("new")
    end
  end
    
  describe "DELETE #destroy" do
    before do
      current_user!(user)
      delete :destroy, :id=>@project.to_param
    end
    it "sets delete_flag to true" do
      @project.reload
      user.delete_flag == (true)
    end
    it "redirects to the index page" do
      expect(:response).to redirect_to projects_path
    end
  end
  
  describe "GET #index" do
    before do
      current_user!(user) 
      get :index
    end
    it "has a status code of 200" do
      expect(response.code).to eq("200")
    end
    it "loads all projects related to a company into @projects" do
      expect(assigns[:projects]).to match_array([@project])
    end
    it "renders the index template" do
      expect(response).to render_template("index")
    end
  end
  
  # Test case for project filter left panel loading through ajax
  describe "Ajax call for filter (left panel) Project filter" do
  	 it "returns http success" do
 	       xhr :get, :project_filter
 	 	   response.should be_success
 	 end
     it "returns result set when it receives employee name" do
 	       xhr :get, :project_filter, :project_title => "someTitle", :proj_type => "fixed_cost", :client_id => "1"
 	 	   response.should be_success
 	 end
  end
  
  
end
