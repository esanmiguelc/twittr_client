require 'spec_helper'


describe Twittr::SignInController do

  def app
    Twittr::SignInController
  end

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
    let (:response_spy) {spy("ResponseParser")} 
    let (:callback) { 'some-url' }
    let (:end_point) { 'https://api.twitter.com/oauth/request_token' }
    let (:parser)  { spy('parser') }
    let (:oauth_signature) { "oauth_signature" }

    before(:each) do
      allow(Twittr::OAuthSignature).to receive(:new).with(callback: "http://#{callback}/twitter_callback", end_point: end_point).and_return(oauth_signature)
    end

    it "builds a Twitter Oauth signature" do
      allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
      post "/twitter_login", {}, {"HTTP_HOST" => callback}

      expect(Twittr::OAuthSignature).to have_received(:new).with(callback: "http://#{callback}/twitter_callback", end_point: end_point)
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
      response_body = "response_body"
      expect(request_spy).to receive(:make_call).and_return(response_body)
      allow(Twittr::ResponseParser).to receive(:new).with(response_body).and_return(response_spy)
      expect(response_spy).to receive(:parse)
      expect(response_spy).to receive(:get_param).with("oauth_token").and_return("user_token")
      expect(response_spy).to receive(:get_param).with("oauth_token_secret").and_return("user_secret")

      post "/twitter_login"

      expect(last_response.redirect?).to eq(true)
      expect(last_response.location).to eq("https://api.twitter.com/oauth/authenticate?oauth_token=user_token")
    end


    it "response saves token in session" do
      allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
      expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
      response_body = "response_body"
      expect(request_spy).to receive(:make_call).and_return(response_body)
      allow(Twittr::ResponseParser).to receive(:new).with(response_body).and_return(response_spy)
      expect(response_spy).to receive(:parse)
      expect(response_spy).to receive(:get_param).with("oauth_token").and_return("user_token")
      expect(response_spy).to receive(:get_param).with("oauth_token_secret").and_return("user_secret")
      
      post "/twitter_login"

      expect(session['token']).to eq("user_token")
    end

    it "response saves secret in session" do
      allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
      expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
      response_body = "response_body"
      expect(request_spy).to receive(:make_call).and_return(response_body)
      allow(Twittr::ResponseParser).to receive(:new).with(response_body).and_return(response_spy)
      expect(response_spy).to receive(:parse)
      expect(response_spy).to receive(:get_param).with("oauth_token").and_return("user_token")
      expect(response_spy).to receive(:get_param).with("oauth_token_secret").and_return("user_secret")
      
      post "/twitter_login"

      expect(session['secret']).to eq("user_secret")
    end
  end

  context "/twitter_callback" do
    let (:request_spy) { spy('requester') }
    let (:callback) { 'some-url' }
    let (:oauth_signature) { "oauth_signature" }

    it "builds a signature" do
      end_point = "https://api.twitter.com/oauth/access_token"
      allow(Twittr::OAuthSignature).to receive(:new).with(end_point: end_point, token: "456").and_return(oauth_signature)
      allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
      get "/twitter_callback", {}, {'rack.session' => { "screen_name" => "esanmiguelc",
                                        "token" => "456",
                                        "secret" => "123"} }

      expect(Twittr::OAuthSignature).to have_received(:new).with(end_point: end_point, token: "456")
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

    context "saving the session variables" do
      before(:each) do
        allow(request_spy).to receive(:get_response_param).with("oauth_token").and_return("123")
        allow(request_spy).to receive(:get_response_param).with("oauth_token_secret").and_return("456")
        allow(request_spy).to receive(:get_response_param).with("screen_name").and_return("esanmiguelc")
      end

      it "sets the screen name to session" do
        allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
        expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)

        get "/twitter_callback"

        expect(session['screen_name']).to eq("esanmiguelc")
      end

      it "sets the token secret to session" do
        allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
        expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)

        get "/twitter_callback"

        expect(session['secret']).to eq("456")
      end

      it "sets the token to session" do
        allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
        expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)

        get "/twitter_callback"

        expect(session['token']).to eq("123")
      end
    end
  end

  def session
    last_request.env['rack.session']
  end
end
