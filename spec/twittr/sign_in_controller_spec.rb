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
    let (:request_spy) { spy('requester') }
    let (:url) { 'some-url' }
    let (:oauth_signature) { "oauth_signature" }

    before(:each) do
      allow(Twittr::OAuthSignature).to receive(:new).with(url).and_return(oauth_signature)
    end

    it "builds a Twitter Oauth signature" do
      post "/twitter_login", {}, {"HTTP_HOST" => url}

      expect(Twittr::OAuthSignature).to have_received(:new).with(url)
    end

    it "make a request with OAuth signature" do
      allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
      expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
      expect(request_spy).to receive(:make_call)

      post "/twitter_login"

    end

    it "redirects with oauth token" do
      allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
      expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
      allow(request_spy).to receive(:get_param).with("oauth_token").and_return("user_token")
      allow(request_spy).to receive(:get_param).with("oauth_token_secret").and_return("user_secret")

      post "/twitter_login"

      expect(last_response.redirect?).to eq(true)
      expect(last_response.location).to eq("https://api.twitter.com/oauth/authenticate?oauth_token=user_token")
    end

    it "token is stored in session" do
      allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
      expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
      allow(request_spy).to receive(:get_param).with("oauth_token").and_return("user_token")
      post "/twitter_login"

      expect(session['token']).to eq("user_token")
    end

    it "secret is stored in session" do
      allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
      expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
      allow(request_spy).to receive(:get_param).with("oauth_token").and_return("user_token")
      allow(request_spy).to receive(:get_param).with("oauth_token_secret").and_return("user_secret")
      
      post "/twitter_login"
      expect(session['secret']).to eq("user_secret")
    end

    def session
      last_request.env['rack.session']
    end
  end
end
