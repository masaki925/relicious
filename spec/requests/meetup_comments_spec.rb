require 'spec_helper'

describe "MeetupComments" do
  before { @meetup = FactoryGirl.create(:meetup) }

  context "when user is NOT logged in" do
    describe "POST /meetups/:meeup_id/meetup_comments" do
      before { post meetup_meetup_comments_path(meetup_id: @meetup.id) }

      specify { response.status.should be(302) }
    end
  end

  context "when user is logged in" do
    describe "POST /meetups/:meeup_id/meetup_comments" do
      it "post request should be success. but before that, should confirm how to manage session[:user_id] as RSpec request seems not support sessions"
    end
  end
end
