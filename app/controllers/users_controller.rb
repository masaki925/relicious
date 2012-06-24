class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])

    fb_user = FbGraph::User.fetch('me', access_token: @user.auth_token)

    if @user.gender.blank? and !fb_user.gender.blank?
      @user.gender = fb_user.gender
    end

    if @user.education.blank? and !fb_user.education.blank?
      fb_user.education.each do |edu_graph|
        @user.education = edu_graph.school.name if edu_graph.type == "College" 
      end 
    end 

    if @user.work.blank? and !fb_user.work.blank?
      @user.work = fb_user.work[0].employer.name
    end

    if @user.locale.blank? and !fb_user.locale.blank?
      @user.locale = fb_user.locale
    end
  end

  # POST /users
  # POST /users.json
  def create
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'please sign up from Facebook OAuth' }
      format.json { head :no_content }
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
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
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
