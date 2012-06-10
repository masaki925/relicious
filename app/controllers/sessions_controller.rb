class SessionsController < ApplicationController
  def callback
    auth = request.env["omniauth.auth"]
    raise "invalid params" unless auth

    if @user = User.find_by_provider_and_provider_uid(auth["provider"], auth["uid"])
      @user.auth_token = auth["credentials"]["token"]
      raise "error: cannot update auth token" unless @user.save
    else
      @user = User.create_with_omniauth(auth)
    end 
    session[:user_id] = @user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil 
    redirect_to root_url
  end
end
