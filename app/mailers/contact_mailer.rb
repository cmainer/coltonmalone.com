class ContactMailer < ActionMailer::Base
  default from: "from@example.com"

  def contactme(params)
  	@params = params
    mail(to: 'ctmalone15@gmail.com', subject: 'Welcome to My Awesome Site')
   # here
  end
end
