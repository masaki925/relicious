require 'spec_helper'

describe TopController do
  context "when user is NOT logged in" do
    describe "GET 'index'" do
      before { get 'index' }

      specify { response.should be_success }
    end
  end

  context "when user is logged in" do
    before do
      @user        = FactoryGirl.create(:user)
      @user_avails = FactoryGirl.create_list(:user_avail, 2, user_id: @user.id)
    end

    describe "GET 'index'" do
      context "when user has created meetup" do
        before { get 'index', {}, {:user_id => @user.id} }

        specify { response.should be_success }
        specify { assigns(:user).should        eq @user }
        specify { assigns(:user_avails).should eq @user_avails }
      end

      context "when user has joined meetup which other user was created" do
        before do
          @other_user = FactoryGirl.create(:user)
          @meetup     = FactoryGirl.create(:meetup, user_id: @other_user.id)
          @user_meetup_permission = FactoryGirl.create(:user_meetup_permission, user_id: @user.id, meetup_id: @meetup.id)
          get 'index', {}, {:user_id => @user.id}
        end

        specify { @user.meetups.should eq Meetup.all }
        specify { assigns(:user_meetups).should eq @user.meetups }
      end
    end
  end
end
