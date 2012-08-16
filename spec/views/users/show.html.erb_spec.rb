require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, FactoryGirl.create(:user) )
    @oauth_user = FactoryGirl.create(:oauth_user, user_id: @user.id)
    @positive_reviews = FactoryGirl.create_list(:user_review,2)
    view.stub(:current_user) { @user }
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Gender/)
    rendered.should match(/Age/)
    rendered.should match(/Birthday/)
    rendered.should match(/Nationality/)
    rendered.should match(/Location/)
    rendered.should match(/Language/)
    rendered.should match(/Availability/)
    rendered.should match(/Favorite food/)
    rendered.should match(/NG food/)
    rendered.should match(/School/)
    rendered.should match(/Work/)
  end
end
