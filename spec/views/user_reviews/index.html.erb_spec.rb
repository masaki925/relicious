require 'spec_helper'

describe "user_reviews/index" do
  before(:each) do
    @reviewed_user = assign(:user, FactoryGirl.create(:user))
    @user_reviews = assign( :user_reviews, FactoryGirl.create_list(:user_review, 2) )
    assign( :meetup, @user_reviews[0].meetup )
  end

  it "renders a list of user_reviews" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "true".to_s, :count => 2
    assert_select "tr>td", :text => "about_user".to_s, :count => 2
    assert_select "tr>td", :text => "about_experience".to_s, :count => 2
    assert_select "tr>td", :text => "1".to_s, :count => 2
    assert_select "tr>td", :text => "2".to_s, :count => 2
    assert_select "tr>td", :text => "3".to_s, :count => 2
  end
end
