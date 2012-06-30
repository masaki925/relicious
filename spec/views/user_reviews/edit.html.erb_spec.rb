require 'spec_helper'

describe "user_reviews/edit" do
  before(:each) do
    @user       = FactoryGirl.create(:user)
    @other_user = assign(:reviewed_user, FactoryGirl.create(:user))
    @user_review = FactoryGirl.create(:user_review, user_id: @user.id, reviewed_user_id: @other_user.id)
    assign(:user_review, @user_review)
  end

  it "renders the edit user_review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_review_path(user_id: @other_user.id, id: @user_review.id), :method => "post" do
      assert_select "select#user_review_reviewed_user_id", :name => "user_review[reviewed_user_id]"
      assert_select "select#user_review_recommend", :name => "user_review[recommend]"
      assert_select "textarea#user_review_about_user", :name => "user_review[about_user]"
      assert_select "textarea#user_review_about_experience", :name => "user_review[about_experience]"
      assert_select "select#user_review_eval_personal", :name => "user_review[eval_personal]"
      assert_select "select#user_review_eval_language", :name => "user_review[eval_language]"
      assert_select "select#user_review_eval_gourmet", :name => "user_review[eval_gourmet]"
    end
  end
end
