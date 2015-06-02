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

   it "redirects on success" do
     mock_interactor = MockInteractor.new
     allow(Twittr::SignInInteractor).to receive(:new).and_return(mock_interactor)
     post "/twitter_login", {}, {"HTTP_HOST" => "www.example.org",
                                 'rack.session' => { "screen_name" => "esanmiguelc",
                                                     "token" => "456",
                                                     "secret" => "123"}  }
     expect(last_response.redirect?).to eq(true)
     expect(last_response.location).to eq("https://api.twitter.com/oauth/authenticate?oauth_token=456")
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

   it "redirects on success" do
     mock_interactor = MockInteractor.new
     allow(Twittr::CallbackInteractor).to receive(:new).and_return(mock_interactor)
     get "/twitter_callback"
     expect(last_response.redirect?).to eq(true)
     expect(last_response.location).to eq("http://example.org/feed")
   end
 end

  def session
    last_request.env['rack.session']
  end
end
