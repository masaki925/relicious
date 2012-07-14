class MeetupsController < ApplicationController
  before_filter :require_authentication, :except => [:show]

  # GET /meetups
  # GET /meetups.json
  def index
    @meetups = Meetup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meetups }
    end
  end

  # GET /meetups/1
  # GET /meetups/1.json
  def show
    @meetup = Meetup.find(params[:id])
    @meetup_users = @meetup.users
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
    @meetup = Meetup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meetup }
    end
  end

  # GET /meetups/1/edit
  def edit
    @meetup = Meetup.find(params[:id])
  end

  # PUT /meetups/1/join
  def join
    @meetup = Meetup.find(params[:id])
    if current_user.meetups.include? @meetup
      flash[:notice] = "WARN: you already joined this meetup"
    else
      current_user.meetups << @meetup
      flash[:notice] = "you successfully joined this meetup!"
    end

    redirect_to meetup_path(@meetup)
  end

  # POST /meetups
  # POST /meetups.json
  def create
    @meetup = Meetup.new(params[:meetup])
    @meetup.user_id = current_user.id

    respond_to do |format|
      if @meetup.save
        current_user.meetups << @meetup
        unless params[:member].blank?
          User.find(params[:member]).meetups << @meetup
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
      format.html { redirect_to meetups_url }
      format.json { head :no_content }
    end
  end
end
