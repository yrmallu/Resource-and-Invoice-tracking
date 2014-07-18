require 'spec_helper'

describe ProjectModule do
  before {@project = FactoryGirl.create(:project)}
  before {@project_module = FactoryGirl.create(:project_module)}
  
  subject {@project_module}
  
  it {should respond_to(:name)}
  it {should respond_to(:description)}
  it {should be_valid}
  
  # it "is invalid without a name" do
#     @project = FactoryGirl.build(:project_module,:name=>"")
#     expect(@project_module).not_to be_valid
#   end
end