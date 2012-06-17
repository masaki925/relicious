require 'spec_helper'

describe "meetups/show" do
  before(:each) do
    @user = FactoryGirl.build(:user)
    @meetup = assign(:meetup, stub_model(Meetup,
      :title => "Title",
      :user => @user,
      :public => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/User/)
    rendered.should match(/false/)
  end
end
