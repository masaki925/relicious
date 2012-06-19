require 'spec_helper'

describe "MeetupComments" do
  describe "GET /meetup_comments" do
    before { @meetup_comment = FactoryGirl.create(:meetup_comment) }
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      meetup = @meetup_comment.meetup
      get meetup_meetup_comments_path(meetup)
      response.status.should be(200)
    end
  end
end
