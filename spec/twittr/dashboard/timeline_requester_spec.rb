require 'spec_helper'
describe Twittr::TimelineRequester do
  context "making calls to the api" do

    before(:each) do
      @signature_mock = double("SignatureMock", :generate_signature => "signature")
      @http_caller_mock = spy("NetHTTP")
      @request_spy = spy("NetHTTPRequest")
      @response = double("Response", :body => [{"one" => "two"}])
      @requester = Twittr::TimelineRequester.new(@signature_mock)
      allow(@http_caller_mock).to receive(:request).and_return(@response)
      allow(@requester).to receive(:request).and_return(@request_spy)
      allow(@requester).to receive(:http_caller).and_return(@http_caller_mock)
      allow(@requester).to receive(:string_auth_values).and_return("123")
    end

    it "generates a signature" do
      @requester.make_call

      expect(@signature_mock).to have_received(:generate_signature)
    end

    it "adds authorization field to the request" do
     @requester.make_call

     expect(@request_spy).to have_received(:add_field)
    end

    it "makes the http request to the api" do
      @requester.make_call

      expect(@http_caller_mock).to have_received(:request).with(@request_spy)
    end

    it "returns the content body" do
      @requester.make_call
      expect(@response).to have_received(:body)
      expect(@response.body).to eq([{"one" => "two"}])
    end
  end
end
