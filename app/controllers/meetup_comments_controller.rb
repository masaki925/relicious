class MeetupCommentsController < ApplicationController
  before_filter :require_authentication
  before_filter :require_member

  # POST /meetup_comments
  # POST /meetup_comments.json
  def create
    @meetup_comment = MeetupComment.new(params[:meetup_comment])
    @meetup_comment.meetup_id = params[:meetup_id]
    @meetup_comment.user_id = session[:user_id]

    respond_to do |format|
      if @meetup_comment.save
        @commented_user    = current_user
        @meetup  = @meetup_comment.meetup
        @members = @meetup.users.select {|u| u != current_user}

        @members.each do |user_to_email|
          UserMailer.meetup_comment_email(user_to_email, @commented_user, @meetup).deliver
        end

        format.html { redirect_to meetup_path(id: params[:meetup_id]) }
        format.json { render json: @meetup_comment, status: :created, location: meetup_path(:id => params[:meetup_id]) }
      else
        format.html { redirect_to meetup_path(id: params[:meetup_id]), notice: @meetup_comment.errors.full_messages.join }
        format.json { render json: @meetup_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meetup_comments/1
  # PUT /meetup_comments/1.json
  def update
    @meetup_comment = MeetupComment.find(params[:id])

    respond_to do |format|
      if @meetup_comment.update_attributes(params[:meetup_comment])
        format.html { redirect_to meetup_path(id: params[:meetup_id]), notice: 'Meetup comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to meetup_path(id: params[:meetup_id]), notice: @meetup_comment.errors.full_messages.join }
        format.json { render json: @meetup_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetup_comments/1
  # DELETE /meetup_comments/1.json
  def destroy
    @meetup_comment = MeetupComment.find(params[:id])
    if @meetup_comment.user_id == current_user.id
      @meetup = @meetup_comment.meetup
      @meetup_comment.destroy
    end

    respond_to do |format|
      format.html { redirect_to meetup_path(id: params[:meetup_id]), notice: 'Meetup comment was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
  def require_member
    unless UserMeetupPermission.find_by_user_id_and_meetup_id(current_user.id, params[:meetup_id])
      redirect_to root_path, notice: "you don't have permission to do it"
      return
    end
  end
end
