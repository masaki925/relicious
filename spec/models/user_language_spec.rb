require 'spec_helper'

describe UserLanguage do
  describe "UserLanguage#create" do
    before { @user_language = FactoryGirl.build(:user_language) }

    context "without user_id" do
      before { @user_language.user_id = nil }
      specify { @user_language.should have(1).errors_on(:user_id) }
    end

    context "without language_id" do
      before { @user_language.language_id = nil }
      specify { @user_language.should have(1).errors_on(:language_id) }
    end
  end
end
