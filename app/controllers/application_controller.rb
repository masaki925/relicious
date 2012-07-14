class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  helper_method :current_user

  def require_authentication
    unless current_user
      redirect_to root_path, notice: 'please login to use this application'
      #render :text => {:result => 'ng', :message => 'please login to use this application'}.to_json, :status => 401 
      #response.headers['x-ll-requireauth'] = 'true'
    end
  end

  private
  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue
      reset_session
    end 
  end 

  def set_locale
    if current_user
      if current_user.locale =~ /ja/
        I18n.locale = :ja
      end
    else
      if params[:lang]
        I18n.locale = params[:lang]
      end
    end
  end
end
