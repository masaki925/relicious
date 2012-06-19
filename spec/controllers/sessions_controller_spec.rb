require 'spec_helper'

describe SessionsController do
  #
  context "when user NOT logged in" do
    describe "GET 'callback'" do
      before do
        auth_info = {
          "provider"    => "provider_sample",
          "uid"         => 100000000,
          "info"        => {
            "name"     => "name_sample",
            "email"    => "example@example.com",
            "birthday" => "2011-01-11",
            "nickname" => "nickname_example",
          },
          "credentials" => { "token" => "token_example" },
        }

        request.env["omniauth.auth"] = auth_info
        get 'callback'
      end

      specify { assigns(:user).should_not be_nil }
      it "redirect to users path"
      #specify { response.should redirect_to(root_path) }

      context "with invalid env" do
        it "check auth code and show error message"
      end
      context "with valid env" do
        it "check auth code and create new user"
      end
    end

    describe "GET 'destroy'" do
      before { get 'destroy' }
      specify { response.should redirect_to(root_path) }
    end
  end

  #
  context "when user logged in" do
    describe "GET 'callback'" do
      context "has valid session" do
        it "returns http error"
      end
      context "has invalid session" do
        it "update auth token"
        it "returns http success"
      end
    end

    describe "GET 'destroy'" do
      before { get 'destroy' }
      specify { response.should redirect_to(root_path) }
    end
  end
end

