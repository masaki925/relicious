require 'spec_helper'

describe "layouts/application.html.erb" do
  context "when user is NOT logged in" do
    it "renders log in link" do
      render
      rendered.should match(/auth\/facebook/)
    end
  end

  context "when user logged in" do
    before do
      @user = FactoryGirl.create(:user)
      assign(:user, @user)
    end

    it "renders log out link" do
      render
      rendered.should match(/\/logout/)
    end
  end
end

