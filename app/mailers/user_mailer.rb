# -*- coding: utf-8 -*-

class UserMailer < ActionMailer::Base
  default from: "noreply@relicious.me"

  def info_email(user)
    @user = user
    set_locale(@user)

    mail( :to => user.email,
          :subject => I18n.t("user_mailer.info_email.subject") )
  end

  def invite_email(invited_user, created_user, meetup)
    @invited_user = invited_user
    @created_user = created_user
    @meetup       = meetup

    set_locale(@invited_user)

    mail( :to => @invited_user.email,
          :subject => I18n.t("user_mailer.invite_email.subject", created_user_name: created_user.name, meetup_title: meetup.title ) )
  end

  def meetup_comment_email(user, commented_user, meetup)
    @user           = user
    @meetup         = meetup
    @commented_user = commented_user
    @meetup_url     = meetup_url(@meetup)

    set_locale(@user)

    mail(:to => @user.email,
         :subject => "[Relicious]You got a message from #{@commented_user.name} about #{@meetup.title}")
  end

  def meetup_new_email(invited_user, created_user, meetup, meetup_comment)
    @invited_user   = invited_user
    @created_user   = created_user
    @meetup         = meetup
    @meetup_comment = meetup_comment
    @meetup_url     = meetup_url(@meetup)

    set_locale(@invited_user)

    mail(:to => @invited_user.email,
         :subject => I18n.t("user_mailer.meetup_new_email.subject", created_user_name: created_user.name, meetup_title: meetup.title ) )
  end

  def meetup_accept_email( user_to_mail, created_user, meetup )
    @user_to_mail   = user_to_mail
    @created_user   = created_user
    @meetup         = meetup
    @meetup_url     = meetup_url(@meetup)

    set_locale(@user_to_mail)

    mail(:to => @user_to_mail.email,
         :subject => I18n.t("user_mailer.meetup_accept_email.subject", created_user_name: created_user.name, meetup_title: meetup.title ) )
  end

  def meetup_declined_email( user_to_mail, created_user, meetup )
    @user_to_mail   = user_to_mail
    @created_user   = created_user
    @meetup         = meetup
    @meetup_url     = meetup_url(@meetup)

    set_locale(@user_to_mail)

    mail(:to => @user_to_mail.email,
         :subject => I18n.t("user_mailer.meetup_declined_email.subject", created_user_name: created_user.name, meetup_title: meetup.title ) )
  end

  def meetup_update_info_email( user_to_mail, created_user, meetup )
    @user_to_mail   = user_to_mail
    @created_user   = created_user
    @meetup         = meetup
    @meetup_url     = meetup_url(@meetup)

    set_locale(@user_to_mail)

    mail(:to => @user_to_mail.email,
         :subject => I18n.t("user_mailer.meetup_update_info_email.subject", created_user_name: created_user.name, meetup_title: meetup.title ) )
  end

  def welcome_email(user)
    @user = user
    set_locale(@user)

    mail(:to => user.email,
         :subject => "[Relicious]Thank your for your registration in Relicious!!")
  end

  def remind_review_mail( user_to_mail, review_target_user, meetup )
    @user_to_mail       = user_to_mail
    @review_target_user = review_target_user
    @meetup             = meetup
    @review_url         = new_user_review_url( @review_target_user )

    set_locale( @user_to_mail )

    mail( :to => @user_to_mail.email,
          :subject => I18n.t( "user_mailer.remind_review_mail.subject", review_target_user_name: review_target_user.name, meetup_title: meetup.title ) )
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
