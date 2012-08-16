require 'spec_helper'

describe SessionsController do
  #
  def valid_auth_info
    {
      "provider"    => "facebook",
      "uid"         => 100000,
      "info"        => {
      "name"     => "name_sample",
      "email"    => "example@example.com",
      "birthday" => "2011-01-11",
      "nickname" => "nickname_example",
      },
      "credentials" => { "token" => "token_example" },
    }
  end
  def invalid_auth_info
    {}
  end

  context "when user already connected with OAuth" do
    before { @oauth_user = FactoryGirl.create(:oauth_user) }

    context "when user already registered" do
      before do
        @user = FactoryGirl.create(:user)
        @oauth_user.update_attributes(user_id: @user.id)
      end

      describe "GET 'callback'" do
        context "has valid params" do
          before do
            @auth_token_test_string = "it should be replaced when user logged in via OAuth"
            request.env["omniauth.auth"] = valid_auth_info
            get 'callback'
          end

          specify { assigns(:oauth_user).auth_token.should_not eq @auth_token_test_string }
          specify { assigns(:user).should eq @user }
        end

        context "has invalid params" do
        end
      end
    end

    context "when user is not registered yet" do
      describe "GET 'callback'" do
        context "has valid params" do
          before do
            @auth_token_test_string = "it should be replaced when user logged in via OAuth"
            request.env["omniauth.auth"] = valid_auth_info
            get 'callback'
          end
    
          specify { assigns(:oauth_user).auth_token.should_not eq @auth_token_test_string }
          specify { session[:oauth_user_id].should eq @oauth_user.id }
          specify { response.should redirect_to( new_user_path ) }
        end
    
        context "has invalid params" do
          it "error handling"
        end
      end
    
      describe "GET 'destroy'" do
        before { get 'destroy' }
        specify { response.should redirect_to(root_path) }
      end
    end
  end

  context "when user is not connected with OAuth yet" do
    describe "GET 'callback'" do
      context "has valid params" do
        before do
          request.env["omniauth.auth"] = valid_auth_info
          get 'callback'
        end

        specify { assigns(:oauth_user).should_not be_nil }
        specify { session[:oauth_user_id].should eq assigns(:oauth_user).id }
      end
      context "has invalid params" do
      end
    end
  end
end

