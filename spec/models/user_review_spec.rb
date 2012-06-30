require 'spec_helper'

describe UserReview do
  describe 'UserReview#create' do
    before do
      @user_review = FactoryGirl.create(:user_review)
    end

    context 'without user_id' do
      before { @user_review.user_id = '' }
      specify { @user_review.should have(1).errors_on(:user_id) }
    end

    context 'without meetup_id' do
      before { @user_review.meetup_id = '' }
      specify { @user_review.should have(1).errors_on(:meetup_id) }
    end

    context 'without reviewed_user_id' do
      before { @user_review.reviewed_user_id = '' }
      specify { @user_review.should have(1).errors_on(:reviewed_user_id) }
    end
  end
end
