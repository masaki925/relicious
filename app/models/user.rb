class User < ActiveRecord::Base
  attr_accessible :auth_token, :birthday, :device_token, :education, :email, :introduction, :name, :provider_uid, :provider, :screen_name, :work

  email_regex    = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :provider,     :presence => true
  validates :provider_uid, :presence => true
  validates :name,         :presence => true
  validates :email,        :presence => true,
                             :format => { :with => email_regex },
                             :uniqueness => true
  validates :auth_token,   :presence => true

  def self.create_with_omniauth(auth)
    user = User.new(
      :provider      => auth["provider"],
      :provider_uid  => auth["uid"],
      :name          => auth["info"]["name"],
      :email         => auth["info"]["email"],
      :birthday      => auth["info"]["birthday"],
      :screen_name   => auth["info"]["nickname"],
      :auth_token    => auth["credentials"]["token"]
    )

    raise user.errors.messages.to_s unless user.save

    #update_notifications_newcomer(user)
    user
  end
end
