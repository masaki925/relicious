class UserReviewsController < ApplicationController
  # GET /user_reviews
  # GET /user_reviews.json
  def index
    @user = User.find(params[:user_id])
    @user_reviews = UserReview.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_reviews }
    end
  end

  # GET /user_reviews/1
  # GET /user_reviews/1.json
  def show
    @reviewed_user = User.find(params[:user_id])
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_review }
    end
  end

  # GET /user_reviews/1/edit
  def edit
    @reviewed_user = User.find(params[:user_id])
    @user_review = UserReview.find(params[:id])
  end

  # POST /user_reviews
  # POST /user_reviews.json
  def create
    @user = User.find(params[:user_id])
    @user_review = UserReview.new(params[:user_review])

    respond_to do |format|
      if @user_review.save
        format.html { redirect_to user_reviews_path(user_id: @user.id, id: @user_review.id), notice: 'User review was successfully created.' }
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
    @user = User.find(params[:user_id])
    @user_review = UserReview.find(params[:id])

    respond_to do |format|
      if @user_review.update_attributes(params[:user_review])
        format.html { redirect_to user_reviews_path(user_id: @user.id, id: @user_review.id), notice: 'User review was successfully updated.' }
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
end
