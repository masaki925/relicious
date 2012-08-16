require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user)
    @oauth_user = FactoryGirl.create(:oauth_user, user_id: @user.id)
  end

  describe 'User#create' do
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

  describe "User#user_languages" do
    before { @user_languages = FactoryGirl.create_list(:user_language, 2, user_id: @user.id) }
    specify { @user.user_languages.should eq @user_languages }
  end
end

