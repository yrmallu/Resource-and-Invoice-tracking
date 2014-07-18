require 'spec_helper'

describe Project do
  before {@project = FactoryGirl.create(:project)}
  
  subject {@project}
  
  it {should respond_to(:title)}
  it {should respond_to(:start_date)}
  it {should respond_to(:description)}
  it {should respond_to(:end_date)}
  it {should be_valid}
  
  it "is invalid without a title" do
    @project = FactoryGirl.build(:project,:title=>"")
    expect(@project).not_to be_valid
  end
end