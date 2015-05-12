require 'spec_helper'
require 'cgi'
require 'base64'

describe Twittr::OAuthPostRequest do

  context "url" do
    it "has a url to make the request" do
      url = "http://www.example.com"
      post_request = create_request(url)
      expect(post_request).to have_attributes(:url => url)
    end
  end

  context "generate_signature" do
    it "generates the correct hashing signature" do
      url = "www.example.com"
      consumer_secret = "123"
      params = {
        "oauth_consumer_key" => "123",
        "oauth_nonce" => "12345678901234567890123456789012"
      }

      post_request = create_request(url, consumer_secret, params)

      post_request.generate_signature

      expect(post_request.get_param("oauth_signature")).to eq(make_signature(url, params, consumer_secret))
    end

    def make_signature(url, params, cons_secret)
      joined_params = CGI.escape(params.sort.map { |values| "#{values[0]}=#{values[1]}" }.join("&"))
      string_base = "POST&#{CGI.escape(url)}&#{joined_params}"
      key = "#{cons_secret}&"
      digest = OpenSSL::Digest.new('sha1')
      CGI.escape(Base64.encode64(OpenSSL::HMAC.digest(digest, key, string_base)).strip)
    end
  end

  context "auth_params" do
    it "sets an auth param" do
      post_request = create_request
      post_request.add_oauth_param("callback", "thisIsCallbackRoute")
      expect(post_request.contains_auth_param?("callback")).to be true
    end
  end

  context "#url_to_uri" do
    it "returns a uri" do
      post_request = create_request

      expect(post_request.url_to_uri).to be_a URI
    end
  end

  context "#build_auth_header" do
    it "returns the field" do
      params = {
        "oauth_consumer_key" => "someKey",
        "oauth_nonce" => "123"
      }

      authorization_value = "OAuth oauth_consumer_key=someKey, oauth_nonce=123"
      post_request = create_request("www.example.com", nil, params)
      post_request.build_auth_header
      http_object = post_request.post_request

      values = http_object.fetch("Authorization")
      expect(values).to eq(authorization_value)
    end
  end

  it "has authorization params" do
    post_request = create_request
    expect(post_request).to respond_to(:oauth_params)
  end

  def create_request(url = "www.example.com", consumer_secret = nil, params = {})
    clone_params = params.dup
    Twittr::OAuthPostRequest.new(url, {consumer_secret: consumer_secret, oauth_params: clone_params})
  end
end
