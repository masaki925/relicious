class TopController < ApplicationController
  def index
    @recent_meetups = Meetup.all(limit: 3)
    if @user = current_user
      @user_avails = @user.user_avails 
      @user_meetups = @user.meetups
    end
  end
end
