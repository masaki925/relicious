require 'spec_helper'

describe User do
  setup do
    @user = User.new
  end

  context 'when uesr is not logged in' do
    describe 'User#create' do
      context 'without provider' do
        it 'should raise error' do
          @user.should_not be_valid
          @user.provider = 'facebook'
          @user.should be_valid
        end
      end
    end
  end
end
