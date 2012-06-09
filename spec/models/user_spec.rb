require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user)
  end

  context 'when uesr is not logged in' do
    describe 'User#create' do
      context 'without provider' do
        before { @user.provider = '' }
        it 'should raise error' do
          @user.should have(1).errors_on(:provider)
        end
      end

      context 'without provider_uid' do
        before { @user.provider_uid = '' }
        it 'should raise error' do
          @user.should have(1).errors_on(:provider_uid)
        end
      end

      context 'without auth_token' do
        before { @user.auth_token = '' }
        it 'should raise error' do
          @user.should have(1).errors_on(:auth_token)
        end
      end

      context 'without name' do
        before { @user.name = '' }
        it 'should raise error' do
          @user.should have(1).errors_on(:name)
        end
      end

      context 'without email' do
        before { @user.email = '' }
        it 'should raise error' do
          @user.should have_at_least(1).errors_on(:email)
        end
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
        it 'should raise error' do
          dup_user = FactoryGirl.build(:user)
          dup_user.should have(1).errors_on(:email)
        end
      end

      context 'without birthday' do
        before { @user.birthday = '' }
        it 'should raise error' do
          @user.should have_at_least(1).errors_on(:birthday)
        end
      end
    end
  end
end
