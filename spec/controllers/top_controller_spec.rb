require 'spec_helper'

describe TopController do
  context "when user NOT logged in" do
    describe "GET 'index'" do
      before { get 'index' }
      specify { response.should be_success }
    end
  end
  context "when user logged in" do
    describe "GET 'index'" do
      before { get 'index' }
      it "redirect to user/:user_id"
    end
  end
end
