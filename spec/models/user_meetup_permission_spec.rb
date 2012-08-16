require 'spec_helper'

describe UserMeetupPermission do
  describe "UserMeetupPermission#create" do
    before { @user_meetup_permission = FactoryGirl.build(:user_meetup_permission) }

    context "without user_id" do
      before { @user_meetup_permission.user_id = nil }
      specify { @user_meetup_permission.should have(1).errors_on(:user_id) }
    end

    context "without meetup_id" do
      before { @user_meetup_permission.meetup_id = nil }
      specify { @user_meetup_permission.should have(1).errors_on(:meetup_id) }
    end

    context "without status" do
      before { @user_meetup_permission.status = nil }
      specify { @user_meetup_permission.should have(1).errors_on(:status) }
    end
  end
end
