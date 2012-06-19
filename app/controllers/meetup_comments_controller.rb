class MeetupCommentsController < ApplicationController
  # GET /meetup_comments
  # GET /meetup_comments.json
  def index
    @meetup_comments = MeetupComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meetup_comments }
    end
  end

  # GET /meetup_comments/1
  # GET /meetup_comments/1.json
  def show
    @meetup_comment = MeetupComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meetup_comment }
    end
  end

  # GET /meetup_comments/new
  # GET /meetup_comments/new.json
  def new
    @meetup_comment = MeetupComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meetup_comment }
    end
  end

  # GET /meetup_comments/1/edit
  def edit
    @meetup_comment = MeetupComment.find(params[:id])
  end

  # POST /meetup_comments
  # POST /meetup_comments.json
  def create
    @meetup_comment = MeetupComment.new(params[:meetup_comment])
    @meetup_comment.meetup_id = params[:meetup_id]
    @meetup_comment.user_id = current_user.id

    respond_to do |format|
      if @meetup_comment.save
        format.html { redirect_to meetup_meetup_comments_path, notice: 'Meetup comment was successfully created.' }
        format.json { render json: @meetup_comment, status: :created, location: @meetup_comment }
      else
        format.html { render action: "new" }
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
        format.html { redirect_to meetup_meetup_comments_path(@meetup_comment.id), notice: 'Meetup comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @meetup_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetup_comments/1
  # DELETE /meetup_comments/1.json
  def destroy
    @meetup_comment = MeetupComment.find(params[:id])
    @meetup = @meetup_comment.meetup
    @meetup_comment.destroy

    respond_to do |format|
      format.html { redirect_to meetup_meetup_comments_path(@meetup) }
      format.json { head :no_content }
    end
  end
end
