require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :name => "Name",
      :email => "Email",
      :provider => "Provider",
      :provider_uid => 1,
      :auth_token => "Auth Token",
      :introduction => "MyText",
      :education => "Education",
      :work => "Work"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Email/)
    rendered.should match(/Provider/)
    rendered.should match(/1/)
    rendered.should match(/MyText/)
    rendered.should match(/Education/)
    rendered.should match(/Work/)
  end
end
