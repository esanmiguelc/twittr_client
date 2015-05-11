require 'spec_helper'

def app
    Twittr::SignInController
end

describe Twittr::SignInController do
    it "gets the index" do
      get "/"
      expect(last_response).to be_ok 
    end
end
