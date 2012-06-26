require 'spec_helper'

describe "meetups/show" do
  context "when user is NOT logged in" do
    it "reject any operations"
  end

  context "when user logged in" do
    before(:each) do
      @meetup_comment = FactoryGirl.create(:meetup_comment)
      @meetup = @meetup_comment.meetup
      @user = @meetup.user
    end

    it "renders attributes in renered HTML" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/Title/)
      rendered.should match(/Member/)
      rendered.should match(/Begin/)
      rendered.should match(/End/)
      rendered.should match(/Area/)
      rendered.should match(/Public/)
      rendered.should match(/Comments/)
      rendered.should match(/Add a Comment/)
    end
  end
end
