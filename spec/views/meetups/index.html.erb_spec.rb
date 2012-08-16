require 'spec_helper'

describe "meetups/index" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    assign(:meetups, FactoryGirl.create_list(:meetup, 2, user_id: @user.id) )

    view.stub(:current_user) { @user }
  end

  it "renders a list of meetups" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "p > a", :text => "Title", :count => 2
    assert_select "p > a", :text => "username", :count => 2
  end
end
