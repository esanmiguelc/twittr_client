describe "Authorizing access" do
  it "returns on success when there is a screen_name stored in session" do
    session = { 'screen_name' => 'esm' }
    interactor = Twittr::AuthorizationInteractor.new(session: session)
    on_success = lambda { true }
    on_fail  = lambda { false } 
    expect(interactor.execute(on_success, on_fail)).to eq(true)
  end

  it "returns on_fail when there is no screen_name" do
    session = {}
    interactor = Twittr::AuthorizationInteractor.new(session: session)
    on_success = lambda { false }
    on_fail  = lambda { true } 
    expect(interactor.execute(on_success, on_fail)).to eq(true)
  end
end
