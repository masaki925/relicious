class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.search(params[:search])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @user_reviews = @user.received_reviews
    @positive_reviews = @user_reviews.find(:all, conditions: ["recommend = ?", true])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    unless params[:id].to_i == current_user.id
      redirect_to users_path, notice: "Forbidden access"
    end

    @user = User.find(params[:id])
    @user_languages = @user.languages
    @user_avails = @user.user_avails
    @all_languages = Language.all

    fb_user = FbGraph::User.fetch('me', access_token: @user.auth_token)

    if @user.gender.blank? and !fb_user.gender.blank?
      @user.gender = fb_user.gender
    end

    likes = Array.new
    if @user.likes.blank? and !fb_user.likes.blank?
      fb_user.likes.each do |like|
        likes << like.name
      end 
    end 
    @likes = likes.join(',')

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

    unless params[:languages].blank?
      @user.languages.clear
      params[:languages].each do |lang_id|
        next if lang_id.blank?
        if @user.languages.include? Language.find(lang_id)
          redirect_to edit_user_path(@user), notice: "ERROR: Language data invalid"
          return
        else
          @user.languages << Language.find(lang_id)
        end
      end
    end

    unless params[:user_avails].blank?
      @user.user_avails.clear

      unless params[:user_avails][:day].blank?
        params[:user_avails][:day].each_with_index do |avail_day, idx|
          next if avail_day.blank?
          next if params[:user_avails][:avail_option][idx].blank?

          user_avail = UserAvail.new(
            day:          avail_day,
            area_id:      params[:user_avails][:area_id][idx],
            avail_option: params[:user_avails][:avail_option][idx]
          )
          unless @user.user_avails << user_avail
            redirect_to user_path(@user), notice: "ERROR: invalid params"
            return
          end
        end
      end
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User profile was successfully updated.' }
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
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end
end
