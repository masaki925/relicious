class UserAvailsController < ApplicationController
  def create
    @user_avail = UserAvail.new(params[:user_avail])
    @user_avail.user_id = params[:user_id]

    respond_to do |format|
      if @user_avail.save
        format.html { redirect_to user_path(id: params[:user_id]) }
        format.json { render json: @user_avail, status: :created, location: user_path(:id => params[:user_id]) }
      else
        format.html { redirect_to user_path(id: params[:user_id]), notice: @user_avail.errors.full_messages.join }
        format.json { render json: @user_avail.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user_avail = UserAvail.find(params[:id])

    respond_to do |format|
      if @user_avail.update_attributes(params[:user_avail])
        format.html { redirect_to user_path(id: params[:user_id]), notice: 'User Availability was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to user_path(id: params[:user_id]), notice: @user_avail.errors.full_messages.join }
        format.json { render json: @user_avail.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_avail = UserAvail.find(params[:id])
    if @user_avail.user_id == current_user.id
      @user = @user_avail.user
      @user_avail.destroy
    else
      flash[:notice] = "ERROR: you are not this data's owner"
    end

    respond_to do |format|
      format.html { redirect_to user_path(@user), notice: 'User Availability was successfully deleted.' }
      format.json { head :no_content }
    end
  end
end
