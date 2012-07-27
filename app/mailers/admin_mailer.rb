class AdminMailer < ActionMailer::Base
  default from: "noreply@relicious.me"
  @@admin = 'masaki925@gmail.com, funkastar.1985@gmail.com'

  def analytics_mail(data)
    @data = data
    mail(:to => @@admin,
         :subject => "[Relicious] Daily Analytics")
  end
end
