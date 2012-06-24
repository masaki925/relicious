require 'spec_helper'

describe TopController do
  context "when user NOT logged in" do
    describe "GET 'index'" do
      before { get 'index' }

      specify { response.should be_success }
    end
  end

  context "when user logged in" do
    before do
      @user        = FactoryGirl.create(:user)
      @user_avails = FactoryGirl.create_list(:user_avail, 2, user_id: @user.id)
    end

    describe "GET 'index'" do
      before { get 'index', {}, {:user_id => @user.id} }

      specify { response.should be_success }
      specify { assigns(:user).should        eq @user }
      specify { assigns(:user_avails).should eq @user_avails }
    end
  end
end
