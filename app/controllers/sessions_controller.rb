class SessionsController < ApplicationController
  def callback
    if request.env["omniauth.auth"].nil? or request.env["omniauth.auth"].empty? 
      redirect_to root_path, :notice => "ERROR: invalid params. please confirm authentication flow and having proper auth code"
      return
    end
    auth = request.env["omniauth.auth"]

    # already connected OAuth
    if @oauth_user = OauthUser.find_by_provider_and_provider_uid(auth["provider"], auth["uid"])
      if @oauth_user.update_attribute( :auth_token, auth["credentials"]["token"] )
        # already registered user
        if @oauth_user.user_id and @user = User.find_by_id_and_active(@oauth_user.user_id, true)
          session[:user_id] = @user.id
          if session[:redirect_to].present?
            redirect_to session[:redirect_to]
            session[:redirect_to] = nil
          else
            redirect_to root_path
          end
          return
        # connected but not registered
        else
          session[:oauth_user_id] = @oauth_user.id
          redirect_to new_user_path
          return
        end
      else
        redirect_to root_path, notice: "We are sorry but OAuth process failed. please contact to service administrator."
        return
      end
    # not yet connected OAuth
    else
      if @oauth_user = OauthUser.create_with_omniauth(auth)
        session[:oauth_user_id] = @oauth_user.id
        redirect_to new_user_path
        return
      else
        redirect_to root_path, :notice => "error: could not connect OAuth. please try it later."
        return
      end
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
