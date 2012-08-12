class UserMailer < ActionMailer::Base
  default from: "noreply@relicious.me"

  def welcome_email(user)
    @user = user

    mail(:to => user.email,
         :subject => "[Relicious]Thank your for your registration in Relicious!!")
  end

  def meetup_comment_email(user, commented_user, meetup)
    @user           = user
    @meetup         = meetup
    @commented_user = commented_user
    @meetup_url     = meetup_url(@meetup)

    mail(:to => @user.email,
         :subject => "[Relicious]You got a message from #{@commented_user.name} about #{@meetup.title}")
  end

  def info_email(user)
    @user = user
    set_locale(@user)
  
    mail(:to => user.email,
         :subject => "[Relicious] information")
  end

  private
  def set_locale(user)
    case user.locale
    when /^ja/
      I18n.locale = :ja
    else
      I18n.locale = :en
    end
  end
end
