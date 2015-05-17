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
    let (:callback) { 'some-url' }
    let (:end_point) { 'https://api.twitter.com/oauth/request_token' }
    let (:oauth_signature) { "oauth_signature" }

    before(:each) do
      allow(Twittr::OAuthSignature).to receive(:new).with(callback, end_point).and_return(oauth_signature)
    end

    it "builds a Twitter Oauth signature" do
      post "/twitter_login", {}, {"HTTP_HOST" => callback}

      expect(Twittr::OAuthSignature).to have_received(:new).with({callback: "http://#{callback}/twitter_callback", end_point: end_point})
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
  end

  context "/twitter_callback" do
    let (:request_spy) { spy('requester') }
    let (:callback) { 'some-url' }
    let (:oauth_signature) { "oauth_signature" }

    it "builds a signature" do
      allow(Twittr::OAuthSignature).to receive(:new)
      get '/twitter_callback'

      expect(Twittr::OAuthSignature).to have_received(:new)
    end

    it "makes a request with the signature" do
      allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
      expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
      expect(request_spy).to receive(:make_call)

      get "/twitter_callback"
    end

    it "redirects to the feed" do
      allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
      expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)

      get "/twitter_callback"

      expect(last_response.redirect?).to eq(true)
      expect(last_response.location).to eq("http://example.org/feed")
    end

    it "sets the screen name to session" do
      allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
      expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
      allow(request_spy).to receive(:get_param).with("screen_name").and_return("esanmiguelc")

      get "/twitter_callback"

      expect(session['screen_name']).to eq("esanmiguelc")
    end
  end
    def session
      last_request.env['rack.session']
    end
end
