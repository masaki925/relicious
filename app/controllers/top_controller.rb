class TopController < ApplicationController
  def index
    @user = current_user
    @user_avails = @user.user_avails if @user
  end
end
