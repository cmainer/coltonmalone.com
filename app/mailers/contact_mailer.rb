class ContactMailer < ActionMailer::Base
  default from: "noreply@coltonmalone.com"

  def contactme(params)
  	@params = params
    mail(to: 'ctmalone15@gmail.com', subject: 'A Message from ColtonMalone.com')
   # here
  end
end
