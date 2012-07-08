class TopController < ApplicationController
  def index
    @recent_meetups = Meetup.all(limit: 3)
    if @user = current_user
      @user_avails = @user.user_avails 
      @user_meetups = @user.meetups

      # 書くべきreview のリスト
      @review_to_write = Array.new
      @user_meetups.each do |meetup|
        meetup.users.each do |user|
          next if user == current_user
          #review = UserReview.find(:all, conditions: ["user_id = ? AND meetup_id = ? AND reviewed_user_id = ?", current_user.id, meetup.id, user.id])
          review = UserReview.find(:all, conditions: ["user_id = ? AND reviewed_user_id = ?", current_user.id, user.id])
          if review.blank?
            @review_to_write << [meetup.id, user.id, user.name]
          end
        end
      end
    end
  end
end
