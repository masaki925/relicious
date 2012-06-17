require 'spec_helper'

describe "meetups/index" do
  before(:each) do
    @user = FactoryGirl.build(:user)
    assign(:meetups, [
      stub_model(Meetup,
        :title => "Title",
        :user => @user,
        :public => false
      ),
      stub_model(Meetup,
        :title => "Title",
        :user => @user,
        :public => false
      )
    ])
  end

  it "renders a list of meetups" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title", :count => 2
    assert_select "tr>td", :text => "username", :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
