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
end
