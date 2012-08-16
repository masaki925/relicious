require 'spec_helper'

describe "users/index" do
  before(:each) do
    @users = FactoryGirl.create_list(:user, 2)
    @user = @users[0]
    view.stub(:current_user) { @user }
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :name => "search[location]"
  end
end
