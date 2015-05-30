describe "updating the status" do

  let(:end_point) {Twittr::UpdateStatusInteractor::END_POINT}
  let(:params) { {
    'status' => 'Hola Mundo'
  } }

  let(:session) { {
    'token' => "123",
    'secret' => "456"
  } }

  let(:request_spy) { spy("Requester") }
  let(:oauth_signature) { "signature" }
  let(:oauth_params) {{end_point: "#{end_point}?status=#{params['status']}",
                                                        token: session['token'],
                                                        secret: session['secret']}}

  it "builds the Oauth Signature" do
    expect(Twittr::OAuthSignature).to receive(:new).with(oauth_params).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::UpdateStatusInteractor.new(params: params, session: session)
    interactor.execute(lambda { true })
  end

  it "creates a request to update status" do
    allow(Twittr::OAuthSignature).to receive(:new).with(oauth_params).and_return(oauth_signature)
    expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::UpdateStatusInteractor.new(params: params, session: session)
    interactor.execute(lambda { true })
  end

  it "makes the request to the API" do
    allow(Twittr::OAuthSignature).to receive(:new).with(oauth_params).and_return(oauth_signature)
    expect(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    interactor = Twittr::UpdateStatusInteractor.new(params: params, session: session)
    interactor.execute(lambda { true })

    expect(request_spy).to have_received(:make_call)
  end

  it "returns true on the success callback" do
    allow(Twittr::OAuthSignature).to receive(:new).with(oauth_params).and_return(oauth_signature)
    allow(Twittr::Requester).to receive(:new).with(oauth_signature).and_return(request_spy)
    json =  "[{}]"
    allow(request_spy).to receive(:make_call).and_return(json)
    interactor = Twittr::UpdateStatusInteractor.new(params: params, session: session)
    on_success = lambda { true }
    expect(interactor.execute(on_success)).to eq(true)
  end
end
