require 'spec_helper'

describe "layouts/application.html.erb" do
  before { view.stub(:current_user) { @user } }

  context "when user is NOT logged in" do
    it "renders log in link" do
      render
      rendered.should match(/auth\/facebook/)
    end
  end

  context "when user logged in" do
    before { @user = FactoryGirl.create(:user) }

    it "renders log out link" do
      render
      rendered.should match(/\/logout/)
    end
  end
end

