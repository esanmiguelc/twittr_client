describe Twittr::Requester do
  context "#make_call" do
    it "makes a call to the API" do
      mock_call = spy("MockRequester")

      requester = Twittr::Requester.new(mock_call)
      requester.make_call

      expect(mock_call).to have_received(:request)
    end
  end
  context "#get_param" do
    it "makes a request and shows params" do
      mock_call = double("MockHTTPMethod", :body => "oauth_verifier=123&oauth_else=something")
      requester = Twittr::Requester.new(mock_call)
      requester.make_call

      expect(requester.get_param("oauth_verifier")).to eq("123")
    end
  end
end
