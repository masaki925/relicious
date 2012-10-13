class TopController < ApplicationController
  def index
    if @user = current_user
      @user_avails  = @user.user_avails 
      @user_meetups = @user.meetups
      @recent_my_meetups = @user_meetups.where('begin_at > ?', Time.now).order(:begin_at).limit(3)
      @past_my_meetups = @user_meetups - @recent_my_meetups

      # FIXME: performance problem
      @recent_meetups_exceptme  = Meetup.where('fixed = ? AND begin_at > ?', true, Time.now).order(:begin_at).find_all {|a| a.users.include?(@user) == false}

      # FIXME: performance problem
      @users_to_review = User.get_users_to_review(@user)
    else
      @recent_meetups = Meetup.where('public = ? AND fixed = ?', true, true).limit(3).order(:id).reverse_order
    end
  end
end
