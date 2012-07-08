class UserMailer < ActionMailer::Base
  default from: "noreply@relicious.me"

  def welcome_email(user)
    @user = user
    @url  = user_url(@user)

    mail(:to => user.email,
         :subject => "Welcome to Relicious")
  end

  def meetup_comment_email(user, commented_user, meetup)
    @user           = user
    @commented_user = commented_user
    @meetup_url     = meetup_url(meetup)

    mail(:to => @user.email,
         :subject => "Your meetup has updated")
  end
end
