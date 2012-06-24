require 'spec_helper'

describe "top/index.html.erb" do
  context "when user is NOT logged in" do
    it "renders log in bar" do
      render
      rendered.should match(/Relicious Top/)
    end
  end

  context "when user logged in" do
    before do
      @user = FactoryGirl.create(:user)
      assign(:user, @user)
    end

    it "render user home" do
      render
      rendered.should match(/User Home/)
      rendered.should match(/Availability/)
    end
  end
end

