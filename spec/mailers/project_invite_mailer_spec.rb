require "spec_helper"

describe ProjectInviteMailer do
 describe "Project Invite Mailer" do
   let(:user){FactoryGirl.create(:user)}
   let(:mail) { UserMailer.project_invite_email(user) }

   it "sends project invitition" do
     mail.subject.should eq("Project Invite")
     mail.to.should eq([user.email])
     mail.from.should eq(["notifications@example.com"])
   end

   it "renders the body" do
	mail.body.encoded.should match("Welcome to Cuelogic HRMS system\r\n\r\nYou have been invited for :  project \r\n\r\nTo login to the site, just follow this link:  \r\n\r\nThanks for joining and have a great day!")
   end
 end
end
