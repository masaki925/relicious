require 'spec_helper'

describe "users/new" do
  before(:each) do
    assign(:user, stub_model(User,
      :name => "MyString",
      :email => "MyString",
      :provider => "MyString",
      :provider_uid => 1,
      :auth_token => "MyString",
      :introduction => "MyText",
      :education => "MyString",
      :work => "MyString"
    ).as_new_record)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path, :method => "post" do
      assert_select "input#user_name", :name => "user[name]"
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_provider", :name => "user[provider]"
      assert_select "input#user_provider_uid", :name => "user[provider_uid]"
      assert_select "input#user_auth_token", :name => "user[auth_token]"
      assert_select "textarea#user_introduction", :name => "user[introduction]"
      assert_select "input#user_education", :name => "user[education]"
      assert_select "input#user_work", :name => "user[work]"
    end
  end
end
