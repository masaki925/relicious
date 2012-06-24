class User < ActiveRecord::Base
  attr_accessible :name, :screen_name, :email, :birthday, :gender, :locale, :introduction, :education, :work, :location
  email_regex    = /\A([\w+\-.]+@[a-z\d\-.]+\.[a-z]+|)\z/i

  validates :name,         presence: true
  validates :email,        uniqueness: true, format: { with: email_regex }
  validates :provider,     presence: true
  validates :provider_uid, presence: true
  validates :auth_token,   presence: true

  has_many :meetups
  has_many :meetup_comments
  has_many :user_avails

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
end
