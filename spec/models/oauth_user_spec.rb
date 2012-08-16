require 'spec_helper'

describe OauthUser do
  before do
    @oauth_user = FactoryGirl.create(:oauth_user)
  end

  let(:auth_info) { 
    {
      "provider" => "provider_sample",
      "uid"      => 100000000,
      "info"     => {
        "name"     => "name_sample",
        "email"    => "example@example.com",
        "birthday" => "2011-01-11",
        "nickname" => "nickname_example",
      },
      "credentials" => { "token" => "token_example" },
    }
  }

  describe "OauthUser#create_with_omniauth" do
    context "with valid attrebutes" do
      it "should create a new instance and save into DB" do
        lambda {
          OauthUser.create_with_omniauth( auth_info )
        }.should change(OauthUser, :count).by(1)
      end
    end
  end

  describe 'OauthUser#create' do
    context 'without provider' do
      before { @oauth_user.provider = '' }
      specify { @oauth_user.should have(1).errors_on(:provider) }
    end 

    context 'without provider_uid' do
      before { @oauth_user.provider_uid = '' }
      specify { @oauth_user.should have(1).errors_on(:provider_uid) }
    end 

    context 'without auth_token' do
      before { @oauth_user.auth_token = '' }
      specify { @oauth_user.should have(1).errors_on(:auth_token) }
    end 
  end
end
