module MailerMacros
#We can test if mail is sent by using ActionMailer::Base::deliveries to get at a list of the delivered emails

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end
end