class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  helper_method :current_user

  add_breadcrumb 'Top', :root_path

  def require_authentication
    unless current_user
      session[:redirect_to] = request.url
      redirect_to root_path, notice: 'please login to use this application'
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
    if params[:lang]
      I18n.locale = params[:lang]
    else
      if current_user
        if current_user.locale =~ /ja/
          I18n.locale = :ja
        else
          I18n.locale = :en
        end
      else
        I18n.locale = :en
      end
    end
  end
end
