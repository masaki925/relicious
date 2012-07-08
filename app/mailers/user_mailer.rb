class UserMailer < ActionMailer::Base
  default from: "noreply@relicious.me"

  def welcome_email(user)
    @user = user
    @url  = user_url(@user)

    mail(:to => user.email,
         :subject => "Welcome to Relicious")
  end
end
