require 'spec_helper'

describe Department do
 
    before do
       @department = Department.create(name: "DepartmentName", company_id: "1")
     end
  
    # this speciifes which object
    subject { @department }

	# it should respong to department name field
    it { should respond_to(:name) }
	
	# Department name should not be empty if empty then test fails ie if no validations applied in model
	describe "Fields not nil validations" do
		it "is not valid with an empty department name" do
	 	    @department = FactoryGirl.build(:department,:name=>"")
	 	    expect(@department).not_to be_valid
	 	 end
	end
	
	# Check for presence of Dept name	
    context "when name is not present" do
         before { @department.name = " " }
         it { should_not be_valid }
    end

	# Check if same department name is being entered which already exist
	describe "when department name is already taken" do
    	before do
         	dept_with_same_name = @department.dup
         	if dept_with_same_name.name == @department.name
       		 	it { should_not be_valid }
			else
				it { should be_valid }
       		end
  	   end
    end
	 
	# check if department name is max 40 chars 
    describe "when name is too long" do
       before { @department.name = "a" * 41 }
       it { should_not be_valid }
    end
	 
	# check if department name is max 2 chars 
    # describe "with a name that's too short" do
#        before { @department.name = "a" * 1 }
#        it { should be_invalid }
#     end
	
end
