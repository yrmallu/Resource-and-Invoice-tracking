require "spec_helper"

describe UserMailer do
  
  describe "Welcome mail and reset password" do
    let(:user){FactoryGirl.create(:user)}
    let(:mail) { UserMailer.welcome_email(user) }

    it "sends user password reset url when new user is created" do
      mail.subject.should eq("Welcome to HRMS")
      mail.to.should eq([user.email])
      mail.from.should eq(["notifications@example.com"])
    end

    it "renders the body" do
		mail.body.encoded.should match("Welcome to HRMS system\r\n\r\nYou have successfully signed up with hrms \r\n\r\nUsername:  \r\n\r\nTo login to the site, just follow this link: http://cuelogic.co.in \r\n\r\nOR \r\n\r\nTo reset password click on following link: \r\nlink:  \r\n\r\nThanks for joining and have a great day!\r\n")
    end
  end
end