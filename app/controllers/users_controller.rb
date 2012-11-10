class UsersController < ApplicationController
  before_filter :redirect_unless_new_user, only: [:new, :create]
  before_filter :require_authentication, except: [:new, :create, :index]
  before_filter :require_owner, only: [:meetups, :edit]
  before_filter :require_active_user, only: [:show, :edit, :update, :withdraw]

  # GET /users
  # GET /users.json
  def index
    add_breadcrumb "Find people", users_path

    @users = User.search(params[:search])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/:id/meetups
  # GET /users/:id/meetups/:status
  def meetups
    add_breadcrumb "My Meetups", "/users/#{current_user.id}/meetups"

    @user    = User.find(params[:id])
    if params[:status]
      @meetups = Meetup.find_user_meetups(current_user, params[:status])
    else
      @meetups = @user.meetups.order(:updated_at).reverse_order
    end

    respond_to do |format|
      format.html # meetups.html.erb
      format.json { render json: @meetups }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    add_breadcrumb "Profile", user_path

    @user = User.find(params[:id])
    @user_reviews = @user.received_reviews
    @user_languages = @user.user_languages
    @positive_reviews = @user_reviews.find(:all, conditions: ["recommend = ?", true]) || []

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def new
    add_breadcrumb "Sign up", new_user_path

    unless session[:oauth_user_id]
      redirect_to root_path, notice: "please sign up with OAuth connect"
    end
    oauth_user = OauthUser.find(session[:oauth_user_id])
    fb_user = FbGraph::User.fetch('me', access_token: oauth_user.auth_token)

    @user = User.new_with_graph(fb_user)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    add_breadcrumb "Profile", user_path
    add_breadcrumb "Edit", edit_user_path

    @user = User.find(params[:id])
    @user_languages = @user.user_languages
    @user_avails = @user.user_avails
  end

  # POST /users
  # POST /users.json
  def create
    unless session[:oauth_user_id]
      redirect_to root_path, notice: "you need to connect with Facebook account"
      return
    end

    unless oauth_user = OauthUser.find(session[:oauth_user_id])
      redirect_to root_path, notice: "you need to connect with Facebook account"
      return
    end

    unless oauth_user.user_id.blank?
      if User.find(oauth_user.user_id).active
        redirect_to root_path, notice: "you already signed up."
        return
      end
    end

    @user = User.new(params[:user])

    begin
      ActiveRecord::Base.transaction do
        @user.save or raise

        oauth_user.update_attributes(user_id: @user.id)
        
        params[:user_languages].each do |ul|
          next if ul[:language_id].blank?
          @user.user_languages << UserLanguage.new(ul)
        end unless params[:user_languages].blank?

        params[:user_avails].each do |ua|
          next if ua[:day].blank? or ua[:avail_option].blank?
          @user.user_avails << UserAvail.new(ua)
        end unless params[:user_avails].blank?

        session[:user_id] = @user.id
        UserMailer.welcome_email(@user).deliver
        redirect_to root_path
        return
      end
    rescue => e
      @user_languages = @user.user_languages
      @user_avails    = @user.user_avails
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    unless params[:user_languages].blank?
      @user.languages.clear
      params[:user_languages].each do |ul|
        next if ul[:language_id].blank?
        if @user.languages.include? Language.find(ul[:language_id])
          redirect_to edit_user_path(@user), notice: "ERROR: Language data invalid"
          return
        else
          UserLanguage.create(user_id: @user.id, language_id: ul[:language_id], skill: ul[:skill])
        end
      end
    end

    unless params[:user_avails].blank?
      @user.user_avails.clear

      params[:user_avails].each_with_index do |ua, idx|
        next if ua[:day].blank? or ua[:avail_option].blank?

        user_avail = UserAvail.new(
          day:          ua[:day],
          area_id:      ua[:area_id],
          avail_option: ua[:avail_option]
        )
        unless @user.user_avails << user_avail
          redirect_to user_path(@user), notice: "ERROR: invalid params"
          return
        end
      end
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to user_path(@user), notice: 'User profile was successfully updated.' }
        format.json { head :no_content }
      else
        @user_languages = @user.user_languages
        @user_avails    = @user.user_avails

        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  # POST /users/withdraw
  def withdraw
    if current_user.withdraw
      reset_session

      respond_to do |format|
        format.html # withdraw.html.erb
        format.json { render json: { 'status' => 'ok' }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to user_path(current_user), notice: "could not complete withdraw process. please inform it to the service team." }
        format.json { render json: { 'status' => 'ng' }, status: :ok }
      end
    end
  end

  protected
  def redirect_unless_new_user
    redirect_to root_path if current_user
  end

  def require_owner
    unless params[:id].to_i == current_user.id.to_i
      redirect_to root_path, notice: 'Forbidden Access'
      return
    end
  end

  def require_active_user
    return true if user = User.find( params[:id] ) and user.active
    redirect_to root_path, notice: "Forbidden Access"
  end
end
