desc "analytics"
task :analytics => :environment do
  data = Hash.new
  data[:total_user]          = User.all.size
  data[:total_meetup]        = Meetup.all.size
  data[:total_comment]       = MeetupComment.all.size
  data[:total_review]        = UserReview.all.size
  data[:locales]             = User.count(:group => 'locale')
  data[:languages]           = UserLanguage.find(:all, select: "languages.name, count(*) as lang_count", joins: :language, group: "languages.id").inject("") {|result, l| result += "#{l.name}: #{l.lang_count.to_s}\n"}
  data[:total_availability]  = UserAvail.all(conditions: ["user_id is not ?", nil]).size

  AdminMailer.analytics_mail(data).deliver
end
