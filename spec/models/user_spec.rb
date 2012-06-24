require 'spec_helper'

describe User do
  before { @user = FactoryGirl.create(:user) }

  let(:auth_info) { 
    {
    "provider" => "provider_sample",
    "uid"      => 100000000,
    "info"     => { "name"     => "name_sample",
      "email"    => "example@example.com",
      "birthday" => "2011-01-11",
      "nickname" => "nickname_example",
  },
  "credentials" => { "token" => "token_example" },
  }
  }

  describe "User#create_with_omniauth" do
    context "with valid attrebutes" do
      it "should create a new instance and save into DB" do
        lambda {
          User.create_with_omniauth( auth_info )
        }.should change(User, :count).by(1)
      end
    end
  end

  describe 'User#create' do
    context 'without provider' do
      before { @user.provider = '' }
      specify { @user.should have(1).errors_on(:provider) }
    end

    context 'without provider_uid' do
      before { @user.provider_uid = '' }
      specify { @user.should have(1).errors_on(:provider_uid) }
    end

    context 'without auth_token' do
      before { @user.auth_token = '' }
      specify { @user.should have(1).errors_on(:auth_token) }
    end

    context 'without name' do
      before { @user.name = '' }
      specify { @user.should have(1).errors_on(:name) }
    end

    context 'with invalid email' do
      it 'should raise error' do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
        addresses.each do |address|
          @user.email = address
          @user.should_not be_valid
        end
      end
    end
    context 'with duplicate registration of email' do
      before do
        @dup_user = FactoryGirl.build(:user)
        @dup_user.email = @user.email
      end

      subject  { @dup_user } 
      it { should have(1).errors_on(:email) }
    end
  end

  describe "User#user_avails" do
    before { @user_avails = FactoryGirl.create_list(:user_avail, 2, user_id: @user.id) }
    specify { @user.user_avails.should eq @user_avails }
  end
end

