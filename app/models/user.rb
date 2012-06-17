class User < ActiveRecord::Base
  attr_accessible :name, :screen_name, :email, :birthday, :introduction, :education, :work
  email_regex    = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,         :presence => true
  validates :email,        :presence => true,
                             :format => { :with => email_regex },
                             :uniqueness => true
  validates :provider,     :presence => true
  validates :provider_uid, :presence => true
  validates :auth_token,   :presence => true

  def self.create_with_omniauth(auth)
    user = User.new(
      :name          => auth["info"]["name"],
      :screen_name   => auth["info"]["username"],
      :email         => auth["info"]["email"],
      :birthday      => auth["info"]["birthday"],
      :screen_name   => auth["info"]["nickname"],
    )
    user.provider      = auth["provider"]
    user.provider_uid  = auth["uid"]
    user.auth_token    = auth["credentials"]["token"]

    raise user.errors.messages.to_s unless user.save

    #update_notifications_newcomer(user)
    user
  end
end
