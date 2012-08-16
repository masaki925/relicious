require 'spec_helper'

describe "top/index.html.erb" do
  context "when user is NOT logged in" do
    it "renders log in button" do
      render
      rendered.should match(/\/auth\/facebook/)
    end
  end

  context "when user logged in" do
    before do
      @user = FactoryGirl.create(:user)
      assign(:user, @user)
    end

    it "render user top" do
      render
      rendered.should match(/Welcome/)
    end
  end
end

