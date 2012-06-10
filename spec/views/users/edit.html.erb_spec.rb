require 'spec_helper'

describe "users/edit" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :name => "MyString",
      :email => "MyString",
      :provider => "MyString",
      :provider_uid => 1,
      :auth_token => "MyString",
      :introduction => "MyText",
      :education => "MyString",
      :work => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path(@user), :method => "post" do
      assert_select "input#user_name", :name => "user[name]"
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_provider", :name => "user[provider]"
      assert_select "input#user_provider_uid", :name => "user[provider_uid]"
      assert_select "textarea#user_introduction", :name => "user[introduction]"
      assert_select "input#user_education", :name => "user[education]"
      assert_select "input#user_work", :name => "user[work]"
    end
  end
end
