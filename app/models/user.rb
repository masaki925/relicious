class User < ActiveRecord::Base
  attr_accessible :name, :screen_name, :email, :birthday, :gender, :locale, :favorite_food, :ng_food, :introduction, :education, :work, :location, :likes, :nationality
  email_regex    = /\A([\w+\-.]+@[a-z\d\-.]+\.[a-z]+|)\z/i

  validates :name,         presence: true
  validates :email,        presence: true, uniqueness: true, format: { with: email_regex }
  validates :gender,       presence: true
  validates :birthday,     presence: true
  validates :location,     presence: true
  validates :locale,     presence: true
  validates :introduction,  presence: true
  validates :nationality,  presence: true

  #validates_with UserLanguageValidator
  #validates_with UserAvailValidator

  has_many :oauth_users
  has_many :meetup_comments
  has_many :user_avails
  has_many :user_languages
  has_many :user_meetup_permissions
  has_many :meetups,   through: :user_meetup_permissions
  has_many :languages, through: :user_languages
  has_many :sent_reviews,     :foreign_key => 'user_id',          :class_name => "UserReview"
  has_many :received_reviews, :foreign_key => 'reviewed_user_id', :class_name => "UserReview"


  def self.new_with_graph(fb_user)
    user = User.new(
      name:        fb_user.name,
      screen_name: fb_user.username,
      email:       fb_user.email,
      gender:      fb_user.gender,
      locale:      fb_user.locale
    )

    unless fb_user.location.blank?
      user.location = fb_user.location.name
    end

    unless fb_user.birthday.blank?
      m,d,y = fb_user.raw_attributes[:birthday].split('/')
      user.birthday = Time.new(y,m,d,0,0,0)
    end

    likes = Array.new
    unless fb_user.likes.blank?
      fb_user.likes.each do |like|
        likes << like.name
      end 
    end 
    user.likes = likes.join(',')

    unless fb_user.education.blank?
      fb_user.education.each do |edu_graph|
        user.education = edu_graph.school.name if edu_graph.type == "College" 
      end 
    end 

    unless fb_user.work.blank?
      user.work = fb_user.work[0].employer.name
    end 

    user
  end

  def self.search(queries)
    if queries
      if !queries[:time].blank?
        find(:all, include: :user_avails, conditions: ["(user_avails.avail_option = ? OR user_avails.avail_option = ?) AND active = ?", queries[:time], "anyday", true] )
      elsif !queries[:date].blank?
        m,d,y = queries[:date].split('/')
        weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
        w_index = Date.new(y.to_i,m.to_i,d.to_i).wday
        find( :all, include: :user_avails, conditions: ["(user_avails.day = ? OR user_avails.day = ?) AND active = ?", weekdays[w_index], "anyday", true] )
      elsif !queries[:location].blank?
        find( :all, conditions: [ 'location LIKE ? AND active = ?', "%#{queries[:location]}%", true ] )
      else
        find( :all, conditions: [ 'active = ?', true ] )
      end
    else
      find( :all, conditions: [ 'active = ?', true ] )
    end
  end

  # return [User1, User2, ...] or []
  # NOTE: it should be replaced with others such as KVS
  def self.get_users_to_review(user, offset)
    meetups_thesedays      = user.meetups.where( 'begin_at BETWEEN ? AND ?', Time.now - offset, Time.now )
    users_met_thesedays    = meetups_thesedays.map { |m| m.users - [user] }.flatten.uniq
    users_met_thesedays    = users_met_thesedays.select { |u| u.active }
    already_reviewed_users = user.sent_reviews.map { |sr| User.find( sr.reviewed_user_id ) }

    users_met_thesedays - already_reviewed_users
  end

  def meetup_status(meetup)
    UserMeetupPermission.find_by_user_id_and_meetup_id(self.id, meetup.id).try(:status)
  end

  def provider_uid
    OauthUser.find_by_user_id(self.id).provider_uid
  end

  def withdraw
    self.active = false
    self.email  = self.email.sub( /^/, Time.now.strftime('%Y%m%d%H%M') + "DELETE_" )
    self.save
  end
end
