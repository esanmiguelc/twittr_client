require 'spec_helper'

describe "Getting the user information" do
  let(:end_point) {Twittr::GetUserInteractor::END_POINT}
  let(:oauth_signature) { "signature" }
  let(:session) { {
      'token' => "123",
      'screen_name' => "esanmiguelc",
      'secret' => "456"
  }}
  let(:oauth_params) {{end_point: "#{end_point}?screen_name=#{session['screen_name']}",
                                                        token: session['token'],
                                                          http_method: "GET",
                                                          secret: session['secret']}}
  let(:request_spy) { spy("Requester") }

  it "builds the oauth signature" do
    expect(Twittr::OAuthSignature).to receive(:new).with(oauth_params).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::GetUserInteractor.new(session: session)
    interactor.execute(lambda { |json| json })
  end

  it "creates a request to get user information" do
    allow(Twittr::OAuthSignature).to receive(:new).with(oauth_params).and_return(oauth_signature)
    expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::GetUserInteractor.new(session: session)
    interactor.execute(lambda { |json| json })
  end

  it "makes the request to the API" do
    allow(Twittr::OAuthSignature).to receive(:new).with(oauth_params).and_return(oauth_signature)
    expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::GetUserInteractor.new(session: session)
    interactor.execute(lambda { |json| json })

    expect(request_spy).to have_received(:make_call)
  end

  it "returns the json on the success callback" do
    allow(Twittr::OAuthSignature).to receive(:new).with(oauth_params).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    json =  "[{}]"
    allow(request_spy).to receive(:make_call).and_return(json)
    interactor = Twittr::GetUserInteractor.new(session: session)
    on_success = lambda { |json| json }
    expect(interactor.execute(on_success)).to eq(json)
  end
end
