desc "remind_review_mail"
task :remind_review_mail => :environment do
  yesterday_meetups = Meetup.where('fixed = 1 AND begin_at BETWEEN ? AND ?', Time.now - 60*60*24, Time.now)
  yesterday_meetups.each do |y_meetup|
    users_to_mail = y_meetup.users
    users_to_mail.each do |user|
      users_to_review = User.get_users_to_review( user, 60*60*24 )
      users_to_review.each do |r_target_user|
        UserMailer.remind_review_mail( user, r_target_user, y_meetup ).deliver
      end
    end
  end
end

