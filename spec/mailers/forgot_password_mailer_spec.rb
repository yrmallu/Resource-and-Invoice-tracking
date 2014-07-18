require "spec_helper"

describe ForgotPasswordMailer do

  describe "Forgot password" do
    let(:user){FactoryGirl.create(:user)}
    let(:mail) { UserMailer.forgot_password_email(user) }

    it "sends user password reset url" do
      mail.subject.should eq("Forgot password for HRMS")
      mail.to.should eq([user.email])
      mail.from.should eq(["notifications@example.com"])
    end

    it "renders the body" do
		mail.body.encoded.should match("Welcome to Cuelogic HRMS system\r\n\r\nUsername:  \r\n\r\nTo reset password click on following link: \r\nlink:  \r\n\r\nTo login to the site, just follow this link:  \r\n\r\nThanks for joining and have a great day!")
    end
  end
  
end
