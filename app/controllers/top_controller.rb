class TopController < ApplicationController
  def index
    if @user = current_user
      @user_avails  = @user.user_avails 
      @recent_my_meetups = @user.meetups.where('begin_at > ? AND status != ?',
                                               Time.now, MEETUP_STATUS_DECLINED).limit(3).order(:updated_at).reverse_order

      # FIXME: performance problem
      @recent_meetups_exceptme  = Meetup.where('fixed = ? AND begin_at > ?', true, Time.now).order(:updated_at).reverse_order.find_all {|a| a.users.include?(@user) == false}

      # FIXME: performance problem
      @users_to_review = User.get_users_to_review(@user)
    else
      @recent_meetups = Meetup.where('public = ? AND fixed = ?', true, true).limit(3).order(:id).reverse_order
    end
  end
end
