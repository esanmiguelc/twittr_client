require 'spec_helper'

def app
  Twittr::SignInController
end

describe Twittr::SignInController do
  context "/" do
    it "gets the index" do
      get_index
      expect(last_response).to be_ok 
    end

    it "has a form to sign in" do
      get_index
      expect(last_response.body).to include "form" 
    end

    def get_index
      get "/"
    end
  end

  context '/twitter_login' do
    it "redirects after api call is done" do
      post "/twitter_login"
      expect(last_response).to be_redirect
      expect(last_response.location).to include 'https://api.twitter.com/oauth/authenticate?oauth_token='
    end
  end
end
