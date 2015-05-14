require 'spec_helper'
describe Twittr::Requester do
  let(:spy_post_request) { spy("SpyHTTPMethod") }
  let(:requester_mock) { double("MockHTTP", :body => "oauth_verifier=123&oauth_else=something").as_null_object }

  context "calling the api" do
    it "makes a call to the API" do
      requester_spy = spy("SpyHTTP")

      requester = Twittr::Requester.new(requester_mock, spy_post_request)
      requester.make_call

      expect(requester_mock).to have_received(:request).with(spy_post_request)
    end
  end

  context "SSL mode" do
    it "sets to verify_mode" do
      requester = Twittr::Requester.new(requester_mock, spy_post_request)
      expect(requester).to respond_to(:verify_mode=)
    end

    it "delegates to Http requester" do
      requester = Twittr::Requester.new(requester_mock, spy_post_request)
      requester.verify_mode = OpenSSL::SSL::VERIFY_NONE
      expect(requester_mock).to have_received(:verify_mode=)
    end
  end

  context "body of a request" do
    it "sets the request body" do
      requester = Twittr::Requester.new(requester_mock, spy_post_request)
      requester.body = "some=param"
      expect(spy_post_request).to have_received(:body=)
    end
  end

  context "using ssl" do
    it "responds to use_ssl" do
      requester = Twittr::Requester.new(requester_mock, spy_post_request)
      expect(requester).to respond_to(:use_ssl=)
    end

    it "delegates to Http requester" do
      requester = Twittr::Requester.new(requester_mock, spy_post_request)
      requester.use_ssl = true
      expect(requester_mock).to have_received(:use_ssl=)
    end
  end

  context "getting request parameters" do
    it "makes a request and shows params" do
      requester = Twittr::Requester.new(requester_mock, spy_post_request)
      requester.make_call

      expect(requester.get_param("oauth_verifier")).to eq("123")
    end
  end
end
