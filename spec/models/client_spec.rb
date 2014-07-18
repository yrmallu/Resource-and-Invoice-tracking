require 'spec_helper'

describe Client do
  before {@client = FactoryGirl.create(:client)}
  
  subject {@client}
  
  it {should respond_to(:name)}
  it {should respond_to(:website)}
  it {should respond_to(:description)}
  it {should respond_to(:contact_points)}
  it {should respond_to(:address)}
  it {should be_valid}
  
  it "is invalid without a name" do
    @client = FactoryGirl.build(:client,:name=>"")
    expect(@client).not_to be_valid
  end
end
