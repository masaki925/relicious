class UserReviewsController < ApplicationController
  before_filter :load_reviewed_user

  # GET /user_reviews
  # GET /user_reviews.json
  def index
    @user_reviews = UserReview.find_all_by_reviewed_user_id(params[:user_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_reviews }
    end
  end

  # GET /user_reviews/1
  # GET /user_reviews/1.json
  def show
    @user_review = UserReview.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_review }
    end
  end

  # GET /user_reviews/new
  # GET /user_reviews/new.json
  def new
    @user_review = UserReview.new
    @meetup_candidates = current_user.meetups and @reviewed_user.meetups
    redirect_to user_path(@reviewe_user) if @meetup_candidates.blank?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_review }
    end
  end

  # GET /user_reviews/1/edit
  def edit
    @user_review = UserReview.find(params[:id])
    @meetup_candidates = current_user.meetups and @reviewed_user.meetups
    redirect_to user_path(@reviewe_user) if @meetup_candidates.blank?
  end

  # POST /user_reviews
  # POST /user_reviews.json
  def create
    @user_review = UserReview.new(params[:user_review])
    @user_review.user_id = current_user.id
    @user_review.reviewed_user_id = params[:user_id]

    debugger
    respond_to do |format|
      if @user_review.save
        #format.html { redirect_to user_reviews_path(user_id: params[:user_id], id: @user_review.id), notice: 'User review was successfully created.' }
        format.html { redirect_to user_path(id: params[:user_id]), notice: 'User review was successfully created.' }
        format.json { render json: @user_review, status: :created, location: @user_review }
      else
        format.html { render action: "new" }
        format.json { render json: @user_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_reviews/1
  # PUT /user_reviews/1.json
  def update
    @user_review = UserReview.find(params[:id])

    respond_to do |format|
      if @user_review.update_attributes(params[:user_review])
        format.html { redirect_to user_reviews_path(user_id: @reviewed_user.id, id: @user_review.id), notice: 'User review was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_reviews/1
  # DELETE /user_reviews/1.json
  def destroy
    @user_review = UserReview.find(params[:id])
    @user_review.destroy

    respond_to do |format|
      format.html { redirect_to user_reviews_path }
      format.json { head :no_content }
    end
  end
  
  private
  def load_reviewed_user
    @reviewed_user = User.find(params[:user_id])
  end
end
