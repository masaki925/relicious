require "spec_helper"

describe UserReviewsController do
  describe "routing" do
    before { @user = FactoryGirl.create(:user) }

    it "routes to #index" do
      get("/users/#{@user.id}/reviews").should route_to("user_reviews#index", :user_id => @user.id.to_s)
    end

    it "routes to #new" do
      get("/users/#{@user.id}/reviews/new").should route_to("user_reviews#new", :user_id => @user.id.to_s)
    end

    it "routes to #show" do
      get("/users/#{@user.id}/reviews/1").should route_to("user_reviews#show", :user_id => @user.id.to_s, :id => "1")
    end

    it "routes to #edit" do
      get("/users/#{@user.id}/reviews/1/edit").should route_to("user_reviews#edit", :user_id => @user.id.to_s, :id => "1")
    end

    it "routes to #create" do
      post("/users/#{@user.id}/reviews").should route_to("user_reviews#create", :user_id => @user.id.to_s)
    end

    it "routes to #update" do
      put("/users/#{@user.id}/reviews/1").should route_to("user_reviews#update", :user_id => @user.id.to_s, :id => "1")
    end

    it "routes to #destroy" do
      delete("/users/#{@user.id}/reviews/1").should route_to("user_reviews#destroy", :user_id => @user.id.to_s, :id => "1")
    end

  end
end
