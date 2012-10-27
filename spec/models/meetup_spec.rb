require 'spec_helper'

describe Meetup do
  describe 'Meetup#create' do
    before { @meetup = FactoryGirl.build(:meetup) }

    context 'without user_id' do
      before { @meetup.user_id = '' }
      specify { @meetup.should have(1).errors_on(:user_id) }
    end

    context 'without begin_at' do
      before { @meetup.begin_at = '' }
      specify { @meetup.should have(0).errors_on(:begin_at) }
    end

    context 'without end_at' do
      before { @meetup.end_at = '' }
      specify { @meetup.should have(0).errors_on(:end_at) }
    end

    context 'without area_id' do
      before { @meetup.area_id = '' }
      specify { @meetup.should have(0).errors_on(:area_id) }
    end
  end
  
  # the meetup information should be edited by only attending users.
  describe "Meetup#editable?" do
    before do
      @meetup = FactoryGirl.create( :meetup )
      @user   = FactoryGirl.create( :user )
    end

    context "when user is NOT attending" do
      subject { @meetup.editable?(@user) }
      it { should be_nil }
    end

    context "when user is being invited the meetup" do
      before { FactoryGirl.create( :user_meetup_permission, meetup_id: @meetup.id, user_id: @user.id ) }
      subject { @meetup.editable?(@user) }
      it { should be_nil }
    end

    context "when user is attending the meetup" do
      before { FactoryGirl.create( :user_meetup_permission, meetup_id: @meetup.id, user_id: @user.id, status: MEETUP_STATUS_ATTEND ) }
      subject { @meetup.editable?(@user) }
      it { should_not be_nil }
    end
  end
end
