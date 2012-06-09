require 'spec_helper'

describe SessionsController do

  describe "GET 'callback'" do
    context "with valid env" do
      it "returns http success" do
        get 'callback'
        response.should be_success
      end
    end
    context "with invalid env" do
      it "raise error"
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      get 'destroy'
      response.should be_success
    end
  end

end
