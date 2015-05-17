require 'spec_helper'

describe Twittr::Requester do
  let(:spy_post_request) { spy("SpyHTTPMethod") }
  let(:requester_mock) { double("MockHTTP", :body => "oauth_verifier=123&oauth_else=something").as_null_object }
  let(:uri) { double("URI", :host => "example.org", :port => "5000" ) }
  let(:oauth_signature) { 
    double("OAuthSignature", :oauth_headers => 
           {
             "oauth_consumer" => "key",
             "oauth_token" => "token"
           }, 
           :end_point => "example.org",
           :end_point_to_uri => uri,
           :generate_signature => "")
  }

  context "calling the api" do
    let(:post_object) { spy("http_post") }
    let(:http_caller) { spy("http_caller") }

    it "makes a call to the API" do
      allow(Net::HTTP::Post).to receive(:new).with("example.org").and_return(post_object)
      allow(post_object).to receive(:add_field)
      allow(Net::HTTP).to receive(:new).and_return(http_caller)
      requester = create_requester
      requester.make_call

      expect(oauth_signature).to have_received(:generate_signature)
    end

    it "adds the string headers to the method caller" do
      allow(Net::HTTP::Post).to receive(:new).with("example.org").and_return(post_object)
      allow(post_object).to receive(:add_field)
      allow(Net::HTTP).to receive(:new).with("example.org", "5000").and_return(http_caller)
      requester = create_requester
      requester.make_call

      expect(post_object).to have_received(:add_field).with("Authorization", "OAuth oauth_consumer=key, oauth_token=token")
    end

    it "has params after making the call" do
      ok_response = double("OkResponse", :body => "one=two")
      allow(Net::HTTP::Post).to receive(:new).with("example.org").and_return(post_object)
      allow(post_object).to receive(:add_field)
      allow(Net::HTTP).to receive(:new).with("example.org", "5000").and_return(http_caller)
      allow(http_caller).to receive(:request).and_return(ok_response)
      requester = create_requester
      requester.make_call
      expect(requester.response_params).to_not be_empty
    end
  end

  context "body of a request" do
    let(:post_object) { spy("http_post") }
    let(:http_caller) { spy("http_caller") }
    it "sets the request body" do
      allow(Net::HTTP::Post).to receive(:new).with("example.org").and_return(post_object)
      requester = create_requester
      requester.body = "some=param"
      expect(post_object).to have_received(:body=)
    end
  end

  context "adding the header for the request" do
    let(:post_object) { spy("http_post") }
    it "builds the auth header as string" do
      requester = Twittr::Requester.new(oauth_signature)

      expect(requester.string_auth_values).to eq("OAuth oauth_consumer=key, oauth_token=token")
    end

  end
    def create_requester
      Twittr::Requester.new(oauth_signature)
    end
end
