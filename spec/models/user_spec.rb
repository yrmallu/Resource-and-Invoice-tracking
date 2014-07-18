require 'spec_helper'

describe User do
  before {@user = FactoryGirl.build(:user)}
  subject {@user}
  it {should respond_to(:email)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:password)}
  it {should respond_to(:firstname)}
  it {should be_valid}
  
  context "when firstname is not present" do
    let(:user){FactoryGirl.build(:user,:firstname=>"")}
    it {expect(user).not_to be_valid}
  end
  context "when email is not present" do
    let(:user){FactoryGirl.build(:user,:email=>"")}
    it {expect(user).not_to be_valid}
  end
  context "when email format is invalid" do
    it "should not be valid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |address|
        user = FactoryGirl.build(:user,:email=>address)
        expect(user).not_to be_valid
      end
    end
  end
  context "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |address|
        user = FactoryGirl.build(:user,:email=>address)
        expect(user).to be_valid
      end
    end
  end
  context "when email is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.downcase
      user_with_same_email.save
    end
    it {should_not be_valid}
  end
  context "when password is not present" do
    let(:user){FactoryGirl.build(:user,:password=>"")}
    it {expect(user).not_to be_valid}
  end
  context "when password does't match confirmation" do
    let(:user){FactoryGirl.build(:user,:password_confirmation=>"mismatch123")}
    it {expect(user).not_to be_valid}
  end
end