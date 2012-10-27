class MeetupsController < ApplicationController
  before_filter :require_authentication, :except => [:show]
  before_filter :if_private_require_member, :except => [:index, :new, :create]
  before_filter :set_redirect_to_session, :only => [:show]

  # GET /meetups
  # GET /meetups.json
  def index
    add_breadcrumb "Meetups", meetups_path

    @user    = current_user if current_user
    @meetups = Meetup.find_except(@user)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meetups }
    end
  end

  # POST /meetups/1/invite
  def invite
    @ump = UserMeetupPermission.new(user_id: params[:invited_user_id],
                                    meetup_id: params[:id],
                                    status: MEETUP_STATUS_INVITED)

    if @ump.save
      UserMailer.invite_email( User.find(params[:invited_user_id]), current_user, Meetup.find(params[:id]) ).deliver
    else
      flash[:notice] = @ump.errors.messages.each_value {|m| m[0]} 
    end

    redirect_to meetup_path(params[:id])
  end

  # GET /meetups/1
  # GET /meetups/1.json
  def show
    add_breadcrumb "Meetups", meetups_path
    add_breadcrumb "Conversation", meetup_path

    @user   = current_user if current_user
    @meetup = Meetup.find(params[:id])
    @meetup_users = @meetup.users
    @meetup_users_except_me = @meetup_users - [current_user]
    @attend_users   = @meetup_users.select { |u| u.meetup_status(@meetup) == MEETUP_STATUS_ATTEND }
    @invited_users  = @meetup_users.select { |u| u.meetup_status(@meetup) == MEETUP_STATUS_INVITED }
    @declined_users = @meetup_users.select { |u| u.meetup_status(@meetup) == MEETUP_STATUS_DECLINED }
    @meetup_comments = @meetup.meetup_comments
    @not_joined_yet = true unless @meetup.users.include? current_user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meetup }
    end
  end

  # GET /meetups/new
  # GET /meetups/new.json
  def new
    add_breadcrumb "Meetups", meetups_path
    add_breadcrumb "new", new_meetup_path

    @meetup = Meetup.new
    @meetup_comment = MeetupComment.new
    @user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meetup }
    end
  end

  # GET /meetups/1/edit
  def edit
    add_breadcrumb "Meetups", meetups_path
    add_breadcrumb "Edit", edit_meetup_path

    @meetup = Meetup.find(params[:id])
  end

  # PUT /meetups/1/join
  def join
    @meetup = Meetup.find(params[:id])

    @meetup_permission = UserMeetupPermission.new(user_id: current_user.id, meetup_id: @meetup.id, status: MEETUP_STATUS_ATTEND)
    unless @meetup_permission.save
      flash[:notice] = @meetup_permission.errors.message
    end

    redirect_to meetup_path(@meetup)
  end

  # POST /meetups
  # POST /meetups.json
  def create
    @user = current_user

    @meetup = Meetup.new_without_mass_asign(params[:meetup], @user)
    @meetup_comment = MeetupComment.new_without_mass_asign(params[:meetup_comment], @user)

    begin
      ActiveRecord::Base.transaction do
        if @meetup.save or raise
          @meetup_comment.meetup_id = @meetup.id
          if @meetup_comment.save or raise
            @my_meetup_permission = UserMeetupPermission.create(user_id: @user.id, meetup_id: @meetup.id, status: MEETUP_STATUS_ATTEND)
            if params[:member].present?
              if @invitee_meetup_permission = UserMeetupPermission.create(user_id: params[:member], meetup_id: @meetup.id, status: MEETUP_STATUS_INVITED)
                UserMailer.meetup_new_email(User.find(params[:member]), @user, @meetup).deliver
              end
            end

            respond_to do |format|
              format.html { redirect_to @meetup, notice: 'Meetup was successfully created.' }
              format.json { render json: @meetup, status: :created, location: @meetup }
            end
          end
        end
      end
    rescue => e
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @meetup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meetups/1
  # PUT /meetups/1.json
  def update
    @meetup = Meetup.find(params[:id])

    unless @meetup.editable?(current_user)
      redirect_to meetup_path(@meetup), notice: "you don't have permission to do it"
      return
    end

    respond_to do |format|
      if @meetup.update_attributes(params[:meetup])
        format.html { redirect_to @meetup, notice: 'Meetup was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @meetup.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /meetups/1/status
  # POST /meetups/1/status.json
  def status
    unless @meetup_permission = UserMeetupPermission.find_by_user_id_and_meetup_id(current_user.id, @meetup.id)
      redirect_to root_path, notice: "you don't have permission to do it"
      return
    end

    if params[:meetup_status_select].blank?
      redirect_to meetup_path(@meetup), notice: "invalid post data"
      return
    end

    respond_to do |format|
      if @meetup_permission.update_attributes(status: params[:meetup_status_select])
        unless @meetup.fixed
          attend_perms = UserMeetupPermission.find_all_by_meetup_id_and_status(@meetup.id, MEETUP_STATUS_ATTEND)
          @meetup.fixed = true if attend_perms.size > 1
          @meetup.save
        end

        format.html { redirect_to @meetup, notice: 'Meetup status was successfully updated.' }
        format.json { head :no_content }
      else
        debugger
        format.html { redirect_to @meetup, notice: 'failed to change Meetup status.' }
        format.json { render json: @meetup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetups/1
  # DELETE /meetups/1.json
  def destroy
    @meetup = Meetup.find(params[:id])
    if @meetup.user_id == current_user.id
      @meetup.destroy
    else
      flash[:notice] = "ERROR: you are not meetup's owner"
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private
  def set_redirect_to_session
    session[:redirect_to] = request.url
  end

  def if_private_require_member
    @meetup = Meetup.find(params[:id])
    return if @meetup.public

    return if @meetup.users.include? current_user

    unless current_user
      flash[:notice] = 'please login to use this application'
    else
      flash[:notice] = 'you don\'t have permission to do it'
    end
    redirect_to root_path
  end
end
