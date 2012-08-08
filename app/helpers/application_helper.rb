module ApplicationHelper
  def facebook_image_url(user_id, type = 'square')
    if oauth_user = OauthUser.find_by_user_id(user_id)
      "http://graph.facebook.com/#{oauth_user.provider_uid}/picture?type=#{type}"
    else
      "noimage.png"
    end
  end
end
