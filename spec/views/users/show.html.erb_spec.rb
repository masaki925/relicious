require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, FactoryGirl.create(:user) )
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Email/)
    rendered.should_not match(/Provider/)
    rendered.should_not match(/Provider uid/)
    rendered.should match(/MyText/)
    rendered.should match(/Education/)
    rendered.should match(/Work/)
    rendered.should match(/Location/)
    rendered.should match(/Gender/)
    rendered.should match(/Locale/)
  end
end
