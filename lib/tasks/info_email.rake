desc "info_email"
task :info_email => :environment do
  User.all.each do |user|
    UserMailer.info_email(user).deliver
    sleep 1
  end
end
