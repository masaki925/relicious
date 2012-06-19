class SessionsController < ApplicationController
  def callback
    auth = request.env["omniauth.auth"]
    raise "invalid params" unless auth

    if @user = User.find_by_provider_and_provider_uid(auth["provider"], auth["uid"])
      @user.auth_token = auth["credentials"]["token"]
      unless @user.save
        raise "error: cannot update auth token"
      end
    else
      @user = User.create_with_omniauth(auth)
    end 
    session[:user_id] = @user.id
    redirect_to @user
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
