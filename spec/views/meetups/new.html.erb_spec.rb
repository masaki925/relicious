require 'spec_helper'

describe "meetups/new" do
  before(:each) do
    @meetup         = FactoryGirl.build( :meetup )
    @meetup_comment = FactoryGirl.build( :meetup_comment, meetup_id: @meetup.id )
  end

  it "renders new meetup form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => meetups_path, :method => "post" do
      assert_select "input#meetup_title", :name => "meetup[title]"
      assert_select "select#meetup_public", :name => "meetup[public]"
    end
  end
end
