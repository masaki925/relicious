class User < ActiveRecord::Base
  attr_accessible :auth_token, :birthday, :device_token, :education, :email, :introduction, :name, :provicer_uid, :provider, :screen_name, :work

  email_regex    = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :provider,  :presence => true
  validates :provider_uid,  :presence => true
  validates :name,  :presence => true
  validates :email,  :presence => true,
                     :format => { :with => email_regex },
                     :uniqueness => true
  validates :auth_token,  :presence => true
  validates :birthday,  :presence => true
end
