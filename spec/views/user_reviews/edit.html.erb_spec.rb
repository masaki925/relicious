require 'spec_helper'

describe "user_reviews/edit" do
  before(:each) do
    @user       = FactoryGirl.create(:user)
    @other_user = assign(:reviewed_user, FactoryGirl.create(:user))
    @meetup = FactoryGirl.create(:meetup)
    FactoryGirl.create(:user_meetup_permission, user_id: @user.id, meetup_id: @meetup.id, status: MEETUP_STATUS_ATTEND)
    FactoryGirl.create(:user_meetup_permission, user_id: @other_user.id, meetup_id: @meetup.id, status: MEETUP_STATUS_ATTEND)
    @user_review = assign(:user_review, FactoryGirl.create(:user_review, meetup_id: @meetup.id, user_id: @user.id, reviewed_user_id: @other_user.id))
    @meetup_candidates = @user.meetups and @other_user.meetups
    assign(:meetup_candidates, @meetup_candidates)
  end

  it "renders the edit user_review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_review_path(user_id: @other_user.id, id: @user_review.id), :method => "post" do
      assert_select "select#user_review_recommend", :name => "user_review[recommend]"
      assert_select "textarea#user_review_about_user", :name => "user_review[about_user]"
      assert_select "textarea#user_review_about_experience", :name => "user_review[about_experience]"
      assert_select "select#user_review_eval_personal", :name => "user_review[eval_personal]"
      assert_select "select#user_review_eval_language", :name => "user_review[eval_language]"
      assert_select "select#user_review_eval_gourmet", :name => "user_review[eval_gourmet]"
    end
  end
end
