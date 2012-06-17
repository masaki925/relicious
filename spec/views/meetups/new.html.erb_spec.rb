require 'spec_helper'

describe "meetups/new" do
  before(:each) do
    assign(:meetup, stub_model(Meetup,
      :title => "MyString",
      :user => nil,
      :public => false
    ).as_new_record)
  end

  it "renders new meetup form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => meetups_path, :method => "post" do
      assert_select "input#meetup_title", :name => "meetup[title]"
      assert_select "input#meetup_public", :name => "meetup[public]"
    end
  end
end
