require 'spec_helper'

describe "Handling the callack from twitter" do

  let(:oauth_signature) { "signature" }
  let(:session) { {'token' => "456"} }
  let(:request_spy) { spy("Requester") }
  let(:params) { {'oauth_verifier' => '123'} }

  it "has a session" do
    interactor = Twittr::CallbackInteractor.new(session: session)
    expect(interactor.session).to eq(session)
  end

  it "has params" do
    interactor = Twittr::CallbackInteractor.new(params: params)
    expect(interactor.params).to eq(params)
  end

  it "builds a signature" do
    end_point = Twittr::CallbackInteractor::END_POINT
    expect(Twittr::OAuthSignature).to receive(:new).with(end_point: end_point,
                                                         token: "456").and_return(oauth_signature)
    expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::CallbackInteractor.new(session: session, params: params)
    interactor.execute
  end

  it "sets the body for the request" do
    allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    expect(request_spy).to receive(:body=).with("oauth_verifier=123")
    interactor = Twittr::CallbackInteractor.new(params: params, session: session)
    interactor.execute
  end

  it "makes a request to get access tokens" do
    allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
    expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    expect(request_spy).to receive(:make_call)
    interactor = Twittr::CallbackInteractor.new(session: session, params: params)
    interactor.execute
  end

  it "saves the secret in session" do
    allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::CallbackInteractor.new(session: session, params: params) 
    response_body = "Response body"
    response_spy = spy("ResponseSpy")
    allow(request_spy).to receive(:body=).with("oauth_verifier=123")
    allow(request_spy).to receive(:make_call).and_return(response_body)
    allow(Twittr::ResponseParser).to receive(:new).with(response_body).and_return(response_spy)
    expect(response_spy).to receive(:get_param).with("oauth_token").and_return("user_token")
    expect(response_spy).to receive(:get_param).with("oauth_token_secret").and_return("user_secret")
    expect(response_spy).to receive(:get_param).with("oauth_screen_name").and_return("user_screen_name")
    interactor.execute

    expect(session['secret']).to eq("user_secret")
  end

  it "saves the token in session" do
    allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::CallbackInteractor.new(session: session, params: params) 
    response_body = "Response body"
    response_spy = spy("ResponseSpy")
    allow(request_spy).to receive(:body=).with("oauth_verifier=123")
    allow(request_spy).to receive(:make_call).and_return(response_body)
    allow(Twittr::ResponseParser).to receive(:new).with(response_body).and_return(response_spy)
    expect(response_spy).to receive(:get_param).with("oauth_token").and_return("user_token")
    expect(response_spy).to receive(:get_param).with("oauth_token_secret").and_return("user_secret")
    expect(response_spy).to receive(:get_param).with("oauth_screen_name").and_return("user_screen_name")
    interactor.execute

    expect(session['token']).to eq("user_token")
  end

  it "saves the screen name in session" do
    allow(Twittr::OAuthSignature).to receive(:new).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::CallbackInteractor.new(session: session, params: params) 
    response_body = "Response body"
    response_spy = spy("ResponseSpy")
    allow(request_spy).to receive(:body=).with("oauth_verifier=123")
    allow(request_spy).to receive(:make_call).and_return(response_body)
    allow(Twittr::ResponseParser).to receive(:new).with(response_body).and_return(response_spy)
    expect(response_spy).to receive(:get_param).with("oauth_token").and_return("user_token")
    expect(response_spy).to receive(:get_param).with("oauth_token_secret").and_return("user_secret")
    expect(response_spy).to receive(:get_param).with("oauth_screen_name").and_return("user_screen_name")
    interactor.execute

    expect(session['screen_name']).to eq("user_screen_name")
  end
end
