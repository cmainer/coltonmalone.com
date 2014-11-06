class ContactMailer < ActionMailer::Base
  default from: "noreply@coltonmalone.com"

  def contactme(params)
  	@params = params
    mail(to: 'ctmalone15@gmail.com', subject: 'A Message from ColtonMalone.com')
   # here
  end

  def send_simple_message
	  RestClient.post "https://api:key-3ax6xnjp29jd6fds4gc373sgvjxteol0"\
	  "@api.mailgun.net/v2/samples.mailgun.org/messages",
	  :from => "Excited User <excited@samples.mailgun.org>",
	  :to => "devs@mailgun.net",
	  :subject => "Hello",
	  :text => "Testing some Mailgun awesomeness!"
	end
end
