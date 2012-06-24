require 'spec_helper'

describe UserAvailsController do
  context "when user is NOT logged in" do
    it "reject any operations"
  end

  context "when user logged in" do
    context "when user is NOT owner of the data" do
      it "reject any operations"
    end

    context "when user is owner of the data" do
      before { @user = FactoryGirl.create(:user) }

      describe "POST 'create'" do
        before do
          @area = FactoryGirl.create(:area)
        end

        it "create new UserAvail" do
          expect {
            post 'create', {user_id: @user.id, user_avail: FactoryGirl.attributes_for(:user_avail, area_id: @area.id) }, { user_id: @user.id }
          }.to change(UserAvail, :count).by(1)
        end

        specify { response.should be_success }
      end

      describe "POST 'update'" do
        before { @user_avail = FactoryGirl.create(:user_avail) }

        it "update column" do
          post 'update', { user_id: @user_avail.user_id, id: @user_avail.id, user_avail: FactoryGirl.attributes_for(:user_avail, avail_option: "dinner") }

          UserAvail.find(@user_avail.id).avail_option.should_not eq @user_avail.avail_option
        end

        specify { response.should be_success }
      end

      describe "DELETE 'destroy'" do
        before { @user_avail = FactoryGirl.create(:user_avail, user_id: @user.id) }

        it "destroys the requested user_avail" do
          expect {
            delete 'destroy', {user_id: @user.id, id: @user_avail.id }, {user_id: @user.id}
          }.to change(UserAvail, :count).by(-1)
        end

        it "redirects to the meetup detail page" do
          delete 'destroy', {user_id: @user.id, id: @user_avail.id }, {user_id: @user.id}
          response.should redirect_to(user_path(@user))
        end
      end
    end
  end
end
