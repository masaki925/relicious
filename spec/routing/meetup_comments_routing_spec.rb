require "spec_helper"

describe MeetupCommentsController do
  describe "routing" do
    before { @meetup_comment = FactoryGirl.create(:meetup_comment) }

    it "routes to #index" do
      get("/meetups/#{@meetup_comment.meetup.id}/meetup_comments").should route_to("meetup_comments#index", :meetup_id => @meetup_comment.meetup.id.to_s)
    end

    it "routes to #new" do
      get("/meetups/#{@meetup_comment.meetup.id}/meetup_comments/new").should route_to("meetup_comments#new", :meetup_id => @meetup_comment.meetup.id.to_s)
    end

    it "routes to #show" do
      get("/meetups/#{@meetup_comment.meetup.id}/meetup_comments/#{@meetup_comment.id}").should route_to("meetup_comments#show", :meetup_id => @meetup_comment.meetup.id.to_s, :id => @meetup_comment.id.to_s)
    end

    it "routes to #edit" do
      get("/meetups/#{@meetup_comment.meetup.id}/meetup_comments/#{@meetup_comment.id}/edit").should route_to("meetup_comments#edit", :meetup_id => @meetup_comment.meetup.id.to_s, :id => @meetup_comment.id.to_s)
    end

    it "routes to #create" do
      post("/meetups/#{@meetup_comment.meetup.id}/meetup_comments").should route_to("meetup_comments#create", :meetup_id => @meetup_comment.meetup.id.to_s)
    end

    it "routes to #update" do
      put("/meetups/#{@meetup_comment.meetup.id}/meetup_comments/#{@meetup_comment.id}").should route_to("meetup_comments#update", :meetup_id => @meetup_comment.meetup.id.to_s, :id => @meetup_comment.id.to_s)
    end

    it "routes to #destroy" do
      delete("/meetups/#{@meetup_comment.meetup.id}/meetup_comments/#{@meetup_comment.id}").should route_to("meetup_comments#destroy", :meetup_id => @meetup_comment.meetup.id.to_s, :id => @meetup_comment.id.to_s)
    end

  end
end
