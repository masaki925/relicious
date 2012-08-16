require 'spec_helper'

describe "users/edit" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user_languages = @user.user_languages
    assign(:user, @user)
    assign(:all_languages, @all_languages)
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path(@user), :method => "post" do
      assert_select "input#user_name", :name => "user[name]"
      assert_select "input#user_email", :name => "user[email]"
      assert_select "textarea#user_introduction", :name => "user[introduction]"
      assert_select "input#user_education", :name => "user[education]"
      assert_select "input#user_work", :name => "user[work]"
      assert_select "select#user_gender", :name => "user[gender]"
      assert_select "select#user_locale", :name => "user[locale]"
      assert_select "select#user_language_language_id", :name => "user_languages[][language_id]"
      assert_select "select#user_avail_day", :name => "user_avails[][day]"
      assert_select "select#user_avail_option", :name => "user_avails[][avail_option]"
    end
  end
end
