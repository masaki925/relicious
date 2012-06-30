require 'spec_helper'

describe "UserReviews" do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe "GET /meetups/:meetup_id/user_reviews" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get user_reviews_path(user_id: @user.id)
      response.status.should be(200)
    end
  end
end
