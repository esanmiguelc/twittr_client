require 'spec_helper'

describe "Sign in interactor" do
  let(:end_point) {Twittr::SignInInteractor::END_POINT}
  let(:host_address){ "www.example.com" }
  let(:oauth_signature) { "oauth_signature" }
  let(:request_spy) { spy("Requester") }
  let (:response_spy) {spy("ResponseParser")} 

  it "has a host" do
    interactor = Twittr::SignInInteractor.new(:host => host_address)
    expect(interactor.host).to eq(host_address)
  end

  it "has an end-point to twitter" do
    end_point = "https://api.twitter.com/oauth/request_token"
    expect(Twittr::SignInInteractor::END_POINT).to eq(end_point)
  end

  it "has a session" do
    session = {}
    interactor = Twittr::SignInInteractor.new(:session => session)
  end

  it "builds a Twitter Oauth signature" do
    expect(Twittr::OAuthSignature).to receive(:new).with(callback: "http://#{host_address}/twitter_callback", end_point: end_point).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::SignInInteractor.new(:host => host_address, :session => {})
    interactor.execute(lambda { true })
  end

  it "makes a request with OAuth Signature" do
    allow(Twittr::OAuthSignature).to receive(:new).with(callback: "http://#{host_address}/twitter_callback", end_point: end_point).and_return(oauth_signature)
    expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::SignInInteractor.new(:host => host_address, :session => {})
    interactor.execute(lambda { true })
  end

  it "Requester makes the call to the API" do 
    allow(Twittr::OAuthSignature).to receive(:new).with(callback: "http://#{host_address}/twitter_callback", end_point: end_point).and_return(oauth_signature)
    expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::SignInInteractor.new(:host => host_address, :session => {})
    interactor.execute(lambda { true })

    expect(request_spy).to have_received(:make_call)
  end

  it "Parses the response" do
    allow(Twittr::OAuthSignature).to receive(:new).with(callback: "http://#{host_address}/twitter_callback", 
                                                        end_point: end_point).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::SignInInteractor.new(:host => host_address, :session => {})
    response_body = "Response body"
    allow(request_spy).to receive(:make_call).and_return(response_body)
    allow(Twittr::ResponseParser).to receive(:new).with(response_body).and_return(response_spy)
    interactor.execute(lambda { true })

    expect(response_spy).to have_received(:parse)
  end

  it "Saves the response token" do
    allow(Twittr::OAuthSignature).to receive(:new).with(callback: "http://#{host_address}/twitter_callback", 
                                                        end_point: end_point).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    session = {}
    interactor = Twittr::SignInInteractor.new(:host => host_address, :session => session) 
    response_body = "Response body"
    allow(request_spy).to receive(:make_call).and_return(response_body)
    allow(Twittr::ResponseParser).to receive(:new).with(response_body).and_return(response_spy)
    expect(response_spy).to receive(:get_param).with("oauth_token").and_return("user_token")
    expect(response_spy).to receive(:get_param).with("oauth_token_secret").and_return("user_secret")
    interactor.execute(lambda { true })

    expect(session['token']).to eq("user_token")
  end


  it "saves secret in session" do
    allow(Twittr::OAuthSignature).to receive(:new).with(callback: "http://#{host_address}/twitter_callback", 
                                                        end_point: end_point).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    session = {}
    interactor = Twittr::SignInInteractor.new(:host => host_address, :session => session) 
    response_body = "Response body"
    allow(request_spy).to receive(:make_call).and_return(response_body)
    allow(Twittr::ResponseParser).to receive(:new).with(response_body).and_return(response_spy)
    expect(response_spy).to receive(:get_param).with("oauth_token").and_return("user_token")
    expect(response_spy).to receive(:get_param).with("oauth_token_secret").and_return("user_secret")
    interactor.execute(lambda { true })

    expect(session['secret']).to eq("user_secret")
  end

  it "returns the success callback" do
    allow(Twittr::OAuthSignature).to receive(:new).with(callback: "http://#{host_address}/twitter_callback", 
                                                        end_point: end_point).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    session = {}
    interactor = Twittr::SignInInteractor.new(:host => host_address, :session => session) 
    response_body = "Response body"
    allow(request_spy).to receive(:make_call).and_return(response_body)
    allow(Twittr::ResponseParser).to receive(:new).with(response_body).and_return(response_spy)
    allow(response_spy).to receive(:get_param).with("oauth_token").and_return("user_token")
    allow(response_spy).to receive(:get_param).with("oauth_token_secret").and_return("user_secret")
    
    expect(interactor.execute(lambda { true })).to eq(true)
  end
end
