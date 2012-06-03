class User < ActiveRecord::Base
  attr_accessible :auth_token, :birthday, :device_token, :education, :email, :introduction, :name, :provicer_uid, :provider, :screen_name, :work
end
