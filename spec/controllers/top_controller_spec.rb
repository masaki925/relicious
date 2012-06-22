require 'spec_helper'

describe TopController do
  context "when user NOT logged in" do
    describe "GET 'index'" do
      before { get 'index' }

      specify { response.should be_success }
    end
  end

  context "when user logged in" do
    before { @user = FactoryGirl.create(:user) }

    describe "GET 'index'" do
      before { get 'index', {}, {:user_id => @user.id} }

      specify { response.should be_success }
    end
  end
end
