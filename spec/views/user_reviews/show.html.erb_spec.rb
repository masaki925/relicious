require 'spec_helper'

describe "user_reviews/show" do
  before(:each) do
    @reviewed_user = assign(:reviewed_user, FactoryGirl.create(:user))
    @meetup      = assign(:meetup     , FactoryGirl.create(:meetup))
    @user_review = assign(:user_review, FactoryGirl.create(:user_review))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/about_user/)
    rendered.should match(/about_experience/)
  end
end
