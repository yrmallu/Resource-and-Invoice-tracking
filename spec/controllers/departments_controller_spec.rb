require 'spec_helper'

describe DepartmentsController do

	# Test cases should be tested only if the user is logged in so to check if logged in or not
	before :each do
		controller.should_receive(:logged_in?)
		@company = FactoryGirl.create(:company)
	end
	
	let(:user){FactoryGirl.create(:user,:user_type => "employee",:company=>@company, :is_admin=>true)}
	
    let(:department) { FactoryGirl.attributes_for(:department, name: "departmentName",:company=>@company)  }
    
	# Test cases for Department create by ajax
	describe "Creating a Department with Ajax" do
      it "should increment the Department count" do
        expect do
        	xhr :post, :create, :department => department
	    end.to change(Department, :count).by(1)
      end

      it "should respond with success" do
        xhr :post, :create, :department => department
        expect(response).to be_success
      end
    end
	
	# Test cases for Department Edit and redirect after update
	describe 'PUT update' do 
		before :each do 
			current_user!(user)
			@department = FactoryGirl.create(:department, name: "departmentName") 
		end 
			
		context "valid attributes" do 
			it "located the requested @department" do 
				put :update, id: @department, department: FactoryGirl.attributes_for(:department) 
				assigns(:department).should eq(@department) 
			end 
				
			it "changes @department's attributes" do 
				put :update, id: @department, department: FactoryGirl.attributes_for(:department, name: "departmentName") 
				@department.reload 
				@department.name.should eq("departmentName") 
			end 
				
			it "redirects to the show department" do 
				get :show, id: @department, department: FactoryGirl.attributes_for(:department) 
				response.should render_template :show
			end 
		end 
	end
	
	#Test cases for Department Index 	
	describe "GET index" do 
		before do
			current_user!(user)
		end
		it "populates an array of departments" do 
            department1 ,department2 = FactoryGirl.create(:department,:name=>"dept1", :company => @company),FactoryGirl.create(:department,:name=>"dept2",:company => @company)
			get :index 
			expect(assigns(:department)).to match_array([department1, department2]) 
		end 
		
		it "renders the index view" do 
			get :index 
			response.should render_template :index 
		end 
	end	
 	
 	# Test cases for Department Show 
  	describe "GET show" do 
		before do
			current_user!(user)
		end
  		it "assigns the requested department to @department" do
  			 department = FactoryGirl.create(:department) 
  			 get :show, id: department 
			 assigns(:department) == (department) 
  		end 
	
  		it "renders the #show view" do 
  			get :show, id: FactoryGirl.create(:department) 
			response.should render_template :show 
  		end 
  	end
	
	# Test cases for Department Delete and redirect after delete
	describe 'DELETE destroy' do 
		before :each do 
			current_user!(user)
			@department = FactoryGirl.create(:department) 
		end 
	
		it "find department which id to be archived" do 
		    delete :destroy, :id => @department.id
			expect(assigns[:department]).to eq(@department)
		end 
		
		it "asssign true to delete flag ie the record to be archived" do
			delete :destroy, :id => @department
		  	@department.delete_flag = true
		  	expect(@department.delete_flag).to eq(true) if @department.save
		end
	
		it "redirects to department index" do 
			delete :destroy, id: @department 
			response.should redirect_to departments_url 
		end 
	end
	
    describe "Ajax call for Department create" do
       it "returns http success" do
   	       xhr :post, :create, :department => department
   	 	   response.should be_success
   	   end
    end
	
end
