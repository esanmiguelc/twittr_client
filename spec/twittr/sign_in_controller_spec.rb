require 'spec_helper'

def app
  Twittr::SignInController
end

describe Twittr::SignInController do
  context "/" do

    def get_index
      get "/"
    end

    it "gets the index" do
      get_index
      expect(last_response).to be_ok 
    end

    it "has a form to sign in" do
      get_index
      expect(last_response.body).to include("form")
    end
  end
end
