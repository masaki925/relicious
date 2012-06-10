require 'spec_helper'

describe "users/index" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :name => "Name",
        :email => "Email",
        :provider => "Provider",
        :provider_uid => 1,
        :auth_token => "Auth Token",
        :introduction => "MyText",
        :education => "Education",
        :work => "Work"
      ),
      stub_model(User,
        :name => "Name",
        :email => "Email",
        :provider => "Provider",
        :provider_uid => 1,
        :auth_token => "Auth Token",
        :introduction => "MyText",
        :education => "Education",
        :work => "Work"
      )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Provider".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Education".to_s, :count => 2
    assert_select "tr>td", :text => "Work".to_s, :count => 2
  end
end
