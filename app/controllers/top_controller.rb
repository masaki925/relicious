class TopController < ApplicationController
  def index
    if @user = current_user
      @user_avails  = @user.user_avails 
      @user_meetups = @user.meetups
      @recent_my_meetups = @user_meetups.where('begin_at > ?', Time.now)
      @past_my_meetups = @user_meetups - @recent_my_meetups

      # pick up meetups except me
      @recent_meetups_exceptme  = Array.new
      offset = 0
      loop do
        break if @recent_meetups_exceptme.size >= 3
        recent_meetup_candidates = Meetup.all(limit: 10, order: 'id DESC', offset: offset)
        break if recent_meetup_candidates.size <= 0

        recent_meetup_candidates -= @user_meetups
        recent_meetup_candidates.each_with_index do |m_cand, idx|
          break if idx >= 3
          @recent_meetups_exceptme << m_cand
        end
        offset += 10
      end

      # Review to write
      ### FIXME: performance problem will occurs
      @review_to_write = Array.new
      check_list       = Array.new

      @past_my_meetups.each do |meetup|
        meetup.users.each do |user|
          next if user == current_user

          review = UserReview.find(:all, conditions: ["user_id = ? AND reviewed_user_id = ?", current_user.id, user.id])
          if review.blank? && ! check_list.include?(user.id)
            @review_to_write << [meetup.id, user.id, user.name]
            check_list << user.id
          end
        end
      end
    else
      @recent_meetups = Meetup.all(limit: 3, order: 'id DESC', conditions: ["public = ?", 1])
    end
  end
end
