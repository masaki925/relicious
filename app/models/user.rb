class User < ActiveRecord::Base
  attr_accessible :name, :screen_name, :email, :birthday, :gender, :locale, :introduction, :education, :work, :location, :likes
  email_regex    = /\A([\w+\-.]+@[a-z\d\-.]+\.[a-z]+|)\z/i

  validates :name,         presence: true
  validates :email,        uniqueness: true, format: { with: email_regex }
  validates :provider,     presence: true
  validates :provider_uid, presence: true
  validates :auth_token,   presence: true

  has_many :meetup_comments
  has_many :user_avails
  has_many :user_languages
  has_many :user_meetup_permissions
  has_many :meetups,   through: :user_meetup_permissions
  has_many :languages, through: :user_languages
  has_many :sent_reviews,     :foreign_key => 'user_id',          :class_name => "UserReview"
  has_many :received_reviews, :foreign_key => 'reviewed_user_id', :class_name => "UserReview"


  def self.create_with_omniauth(auth)
    user = User.new(
      name:        auth["info"]["name"],
      screen_name: auth["info"]["username"],
      email:       auth["info"]["email"],
      birthday:    auth["info"]["birthday"],
      screen_name: auth["info"]["nickname"],
      location:    auth["info"]["location"],
      screen_name: auth["info"]["nickname"],
    )
    user.provider      = auth["provider"]
    user.provider_uid  = auth["uid"]
    user.auth_token    = auth["credentials"]["token"]

    raise user.errors.messages.to_s unless user.save

    #update_notifications_newcomer(user)
    user
  end

  def self.search(queries)
    if queries
      find(:all, conditions: [ 'location LIKE ?', "%#{queries[:location]}%" ] )
    else
      find(:all)
    end
  end
end
