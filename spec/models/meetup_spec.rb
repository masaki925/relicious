require 'spec_helper'

describe Meetup do
  context 'when uesr is NOT logged in' do
    describe 'Meetup#create' do
      before { @meetup = FactoryGirl.build(:meetup) }
      context 'without user_id' do
        before { @meetup.user_id = '' }
        specify { @meetup.should have(1).errors_on(:user_id) }
      end
    end
  end
  context 'when uesr is logged in' do
    describe 'Meetup#create' do
      before { @meetup = FactoryGirl.build(:meetup) }
      context 'without begin_at' do
        before { @meetup.begin_at = '' }
        specify { @meetup.should have(1).errors_on(:begin_at) }
      end
      context 'without end_at' do
        before { @meetup.end_at = '' }
        specify { @meetup.should have(1).errors_on(:end_at) }
      end
    end
  end
end
