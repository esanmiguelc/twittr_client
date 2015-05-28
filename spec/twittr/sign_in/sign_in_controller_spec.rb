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

 context "/twitter_login" do
   it "calls the interactor" do
     interactor_spy = spy("Interactor")
     allow(interactor_spy).to receive(:execute)
     allow(Twittr::SignInInteractor).to receive(:new).and_return(interactor_spy)
     post "/twitter_login", {}, {"HTTP_HOST" => "www.example.org"}
     expect(Twittr::SignInInteractor).to have_received(:new).with({host: "www.example.org", session: session})
   end

   xit "redirects on success" do
     interactor_double = spy("InteractorDouble")
     allow(Twittr::SignInInteractor).to receive(:new).with(host: "www.example.org", session: { "screen_name" => "esanmiguelc",
                                                                                               "token" => "456",
                                                                                               "secret" => "123"}).and_return(interactor_double)
     allow(interactor_double).to receive(:execute).with("Hello") { |callback| callback.call }
     post "/twitter_login", {}, {"HTTP_HOST" => "www.example.org",
                                 'rack.session' => { "screen_name" => "esanmiguelc",
                                                     "token" => "456",
                                                     "secret" => "123"}  }
     expect(last_response.redirect?).to eq(true)
     expect(last_response.location).to eq("https://api.twitter.com/oauth/authenticate?oauth_token=user_token")
   end
 end

 context "/twitter_callback" do
   it "calls the interactor" do
     interactor_spy = spy("Interactor")
     allow(interactor_spy).to receive(:execute)
     allow(Twittr::CallbackInteractor).to receive(:new).and_return(interactor_spy)
     params = {}
     get "/twitter_callback", params
     expect(Twittr::CallbackInteractor).to have_received(:new).with({params: params, session: session})
   end

   it "calls execute" do
     interactor_spy = spy("Interactor")
     allow(Twittr::CallbackInteractor).to receive(:new).and_return(interactor_spy)

     params = {}
     get "/twitter_callback", params
     expect(Twittr::CallbackInteractor).to have_received(:new).with({params: params, session: session})    
     expect(interactor_spy).to have_received(:execute)
   end

   it "redirects on success"
 end

#context "/twitter_callback" do
#  let (:request_spy) { spy('requester') }
#  let (:callback) { 'some-url' }
#  let (:oauth_signature) { "oauth_signature" }

#  it "builds a signature" do
#    end_point = "https://api.twitter.com/oauth/access_token"
#    allow(Twittr::OAuthSignature).to receive(:new).with(end_point: end_point, token: "456").and_return(oauth_signature)
#    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
#    get "/twitter_callback", {}, {'rack.session' => { "screen_name" => "esanmiguelc",
#                                      "token" => "456",
#                                      "secret" => "123"} }

#    expect(Twittr::OAuthSignature).to have_received(:new).with(end_point: end_point, token: "456")
#  end

#  it "makes a request with the signature" do
#    allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
#    expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
#    expect(request_spy).to receive(:make_call)

#    get "/twitter_callback"
#  end

#  it "redirects to the feed" do
#    allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
#    expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)

#    get "/twitter_callback"

#    expect(last_response.redirect?).to eq(true)
#    expect(last_response.location).to eq("http://example.org/feed")
#  end

#  context "saving the session variables" do
#    before(:each) do
#      allow(request_spy).to receive(:get_response_param).with("oauth_token").and_return("123")
#      allow(request_spy).to receive(:get_response_param).with("oauth_token_secret").and_return("456")
#      allow(request_spy).to receive(:get_response_param).with("screen_name").and_return("esanmiguelc")
#    end

#    it "sets the screen name to session" do
#      allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
#      expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)

#      get "/twitter_callback"

#      expect(session['screen_name']).to eq("esanmiguelc")
#    end

#    it "sets the token secret to session" do
#      allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
#      expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)

#      get "/twitter_callback"

#      expect(session['secret']).to eq("456")
#    end

#    it "sets the token to session" do
#      allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
#      expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)

#      get "/twitter_callback"

#      expect(session['token']).to eq("123")
#    end
#  end
#end
 

  def session
    last_request.env['rack.session']
  end
end
