require 'spec_helper'

describe SessionsController do
  #
  def valid_auth_info
    {
      "provider"    => "facebook",
      "uid"         => 100,
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

  context "when user is NOT registered yet" do
    describe "GET 'callback'" do
      context "with valid env" do
        before do
          request.env["omniauth.auth"] = valid_auth_info
          get 'callback'
        end

        describe "user" do
          specify { assigns(:user).should_not be_nil }
        end
        specify { response.should redirect_to( edit_user_path( assigns(:user) ) ) }
      end

      context "with invalid env" do
        before do
          request.env["omniauth.auth"] = invalid_auth_info
          get 'callback'
        end

        specify { response.should redirect_to( root_path ) }
      end
    end

    describe "GET 'destroy'" do
      before { get 'destroy' }
      specify { response.should redirect_to(root_path) }
    end
  end

  #
  context "when user already registered" do
    before { @user = FactoryGirl.create(:user) }

    describe "GET 'callback'" do
      context "has valid params" do
        before do
          @auth_token_prev = @user.auth_token
          request.env["omniauth.auth"] = valid_auth_info
          get 'callback'
        end

        specify { assigns(:user).auth_token.should_not eq @auth_token_prev }
        specify { response.should redirect_to( root_path ) }
      end

      context "has invalid params" do
        before do
          request.env["omniauth.auth"] = invalid_auth_info
          get 'callback'
        end

        specify { response.should redirect_to( root_path ) }
      end
    end

    describe "GET 'destroy'" do
      before { get 'destroy' }
      specify { response.should redirect_to(root_path) }
    end
  end
end

