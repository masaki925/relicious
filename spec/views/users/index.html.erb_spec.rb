require 'spec_helper'

describe "users/index" do
  before(:each) do
    @users = FactoryGirl.create_list(:user, 2)
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :name => "search[location]"
    assert_select "tr>td", :text => "username".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Education".to_s, :count => 2
    assert_select "tr>td", :text => "Work".to_s, :count => 2
    assert_select "tr>td", :text => "Tokyo".to_s, :count => 2
  end
end
