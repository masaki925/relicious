class OauthUser < ActiveRecord::Base
  attr_accessible :provider, :provider_uid, :auth_token, :user_id

  validates :provider,     presence: true
  validates :provider_uid, presence: true
  validates :auth_token,   presence: true

  belongs_to :user

  def self.create_with_omniauth(auth)
    oauth_user = OauthUser.new(
      provider:     auth["provider"],
      provider_uid: auth["uid"],
      auth_token:   auth["credentials"]["token"]
    )

    raise oauth_user.errors.messages.to_s unless oauth_user.save

    oauth_user
  end
end
