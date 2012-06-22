require 'spec_helper'

describe MeetupComment do
  describe 'MeetupComment#create' do
    before { @meetup_comment = FactoryGirl.create(:meetup_comment) }

    context 'without user_id' do
      before { @meetup_comment.user_id = '' }
      specify { @meetup_comment.should have(1).errors_on(:user_id) }
    end
    context 'without meetup_id' do
      before { @meetup_comment.meetup_id = '' }
      specify { @meetup_comment.should have(1).errors_on(:meetup_id) }
    end
    context 'without body' do
      before { @meetup_comment.body = '' }
      specify { @meetup_comment.should have(1).errors_on(:body) }
    end
  end

  describe 'MeetupComment#show' do
    before { @meetup_comment = FactoryGirl.create(:meetup_comment) }
    subject { @meetup_comment } 
    its(:meetup) { should == Meetup.find(@meetup_comment.meetup_id) }
  end
end
