class AdminMailer < ActionMailer::Base
  default from: "noreply@relicious.me"
  if Rails.env == :production
    @@admin = 'masaki925@gmail.com, funkastar.1985@gmail.com'
  else
    # development
    @@admin = 'masaki925@gmail.com'
  end

  def analytics_mail(data)
    @data = data
    mail(:to => @@admin,
         :subject => "[Relicious] Daily Analytics")
  end
end
