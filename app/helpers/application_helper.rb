module ApplicationHelper
  def facebook_image_link(user, type = 'square', width = 70)
    if user.active
      if oauth_user = OauthUser.find_by_user_id(user.id)
        return link_to image_tag( "http://graph.facebook.com/#{oauth_user.provider_uid}/picture?type=#{type}", width:width, alt:"picture"), user_path(user)
      end
    end

    image_tag( "not_available.jpg", width:width, alt:"picture")
  end
end
