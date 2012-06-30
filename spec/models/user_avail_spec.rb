require 'spec_helper'

describe UserAvail do
  describe 'UserAvail#create' do
    before { @user_avail = FactoryGirl.build(:user_avail) }
    context 'without user_id' do
      before { @user_avail.user_id = '' }
      specify { @user_avail.should have(1).errors_on(:user_id) }
    end

    context 'without day' do
      before { @user_avail.day = '' }
      specify { @user_avail.should have(1).errors_on(:day) }
    end

    context 'without area_id' do
      before { @user_avail.area_id = '' }
      specify { @user_avail.should have(1).errors_on(:area_id) }
    end
  end

  describe 'UserAvail#user' do
    before do
      @user = FactoryGirl.create(:user)
      @user_avail = FactoryGirl.create(:user_avail, user_id: @user.id)
    end

    subject { @user_avail.user }
    it { should eq @user }
  end

  describe 'UserAvail#area' do
    before do
      @area = FactoryGirl.create(:area)
      @user_avail = FactoryGirl.create(:user_avail, area_id: @area.id)
    end

    subject { @user_avail.area }
    it { should eq @area }
  end
end
