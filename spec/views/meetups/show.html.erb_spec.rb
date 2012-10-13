require 'spec_helper'

describe "meetups/show" do
  context "when user is NOT logged in" do
    it "reject any operations"
  end

  context "when user logged in" do
    before(:each) do
      @user            = FactoryGirl.create(:user)
      @meetup          = FactoryGirl.create(:meetup)
      permission       = FactoryGirl.create(:user_meetup_permission,
                                             user_id: @user.id,
                                             meetup_id: @meetup.id)
      @meetup_comments = FactoryGirl.create_list(:meetup_comment, 2, meetup_id: @meetup.id)
      @meetup_users    = @meetup.users
      view.stub(:current_user) { @user }
      @meetup_users_except_me = []
    end

    it "renders attributes in renered HTML" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/Title/)
      rendered.should match(/username/)
      rendered.should match(/Begin at/)
      rendered.should match(/Area/)
      rendered.should match(/Public/)
      rendered.should match(/MyText/)
      rendered.should match(/Send a Message/)
    end
  end
end
