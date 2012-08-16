require 'spec_helper'

describe "layouts/application.html.erb" do
  before do
    view.stub(:render_breadcrumbs) { true }
  end

  context "when user is NOT logged in" do
    before do
      view.stub(:current_user) { false }
    end
  end

  context "when user logged in" do
    before do
      @user = FactoryGirl.create(:user) 
      view.stub(:current_user) { @user }
    end

    it "renders log out link" do
      render
      rendered.should match(/\/logout/)
    end
  end
end

