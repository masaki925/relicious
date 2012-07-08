class SessionsController < ApplicationController
  def callback
    if request.env["omniauth.auth"].nil? or request.env["omniauth.auth"].empty? 
      redirect_to root_path, :notice => "ERROR: invalid params. please confirm authentication flow and having proper auth code"
      return
    end
    auth = request.env["omniauth.auth"]

    # Registered user
    if @user = User.find_by_provider_and_provider_uid(auth["provider"], auth["uid"])
      @user.auth_token = auth["credentials"]["token"]
      if @user.save
        session[:user_id] = @user.id
        redirect_to root_path
        return
      else
        redirect_to root_path, :notice => "error: cannot update auth token"
      end
    # New user
    else
      if @user = User.create_with_omniauth(auth)
        session[:user_id] = @user.id
        UserMailer.welcome_email(@user).deliver
        redirect_to edit_user_path(@user)
        return
      else
        redirect_to root_path, :notice => "error: cannot sign up"
      end
    end 
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
