class MeetupsController < ApplicationController
  before_filter :require_authentication, :except => [:show]
  before_filter :if_private_require_member, :except => [:index, :new, :create]

  # GET /meetups
  # GET /meetups.json
  def index
    add_breadcrumb "Meetups", meetups_path

    @user = current_user if current_user
    my_meetups = @user.meetups.order('id DESC')
    if params[:about] && params[:about] == 'me'
      @meetups = my_meetups
    else
      @meetups = Meetup.all - my_meetups
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meetups }
    end
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
    @user = current_user if current_user

    @meetup = Meetup.new(params[:meetup])
    @meetup.user_id = current_user.id

    respond_to do |format|
      if @meetup.save
        @my_meetup_permission = UserMeetupPermission.create(user_id: current_user.id, meetup_id: @meetup.id, status: MEETUP_STATUS_ATTEND)
        unless params[:member].blank?
          if @invitee_meetup_permission = UserMeetupPermission.create(user_id: params[:member], meetup_id: @meetup.id, status: MEETUP_STATUS_INVITED)
            UserMailer.meetup_new_email(User.find(params[:member]), @user, @meetup).deliver
          end
        end
        format.html { redirect_to @meetup, notice: 'Meetup was successfully created.' }
        format.json { render json: @meetup, status: :created, location: @meetup }
      else
        format.html { render action: "new" }
        format.json { render json: @meetup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meetups/1
  # PUT /meetups/1.json
  def update
    @meetup = Meetup.find(params[:id])

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

  # GET /meetups/1/status?v=xxx
  # GET /meetups/1/status.json?v=xxx
  def status
    @meetup = Meetup.find(params[:id])
    unless @meetup_permission = UserMeetupPermission.find_by_user_id_and_meetup_id(current_user.id, @meetup.id)
      redirect_to root_path, notice: "you don't have permission to do it"
      return
    end

    if params[:stat].blank?
      redirect_to meetup_path(@meetup), notice: "invalid post data"
      return
    end

    respond_to do |format|
      if @meetup_permission.update_attributes(status: params[:stat])
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
  def if_private_require_member
    @meetup = Meetup.find(params[:id])
    return if @meetup.public

    return if @meetup.users.include? current_user

    redirect_to root_path, notice: "you have no permission to do it"
  end
end
