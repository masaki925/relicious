require 'spec_helper'

describe "Meetups" do
  context "when user is NOT logged in" do
  end

  context "when user is logged in" do
    describe "GET /meetups" do
      it "works! (now write some real specs)" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        get meetups_path
        response.status.should be(401)
      end
    end
  end
end
