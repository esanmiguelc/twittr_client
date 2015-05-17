require 'spec_helper'
require 'cgi'
require 'base64'

describe Twittr::OAuthSignature do

  context "#end_point" do
    it "has a end_point to make the request" do
      end_point = "http://www.example.com"
      post_request = create_request(end_point)
      expect(post_request).to have_attributes(:end_point => end_point)
    end
  end

  xcontext "generates a signature for authentication" do
    it "generates the correct string base" do
      end_point = "https://api.twitter.com/1/statuses/update.json"
      request_params = {
        "status" => "Hello%20Ladies%20%2b%20Gentlemen%2c%20a%20signed%20OAuth%20request%21",
        "include_entities" => "true"
      }
      params = {
        "oauth_consumer_key" => "xvz1evFS4wEEPTGEFPHBog",
        "oauth_nonce" => "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
        "oauth_signature_method" => "HMAC-SHA1",
        "oauth_timestamp" => "1318622958",
        "oauth_token" => "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
        "oauth_version" => "1.0"
      }
      parameter_string = request_params.merge(params)
      joined_params = parameter_string.sort.map { |values| "#{values[0]}=#{values[1]}" }.join("&")
      post_request = create_request(end_point)
      expect(post_request.string_base(joined_params)).to eq(string_base)
    end

    def string_base
      "POST&https%3A%2F%2Fapi.twitter.com%2F1%2Fstatuses%2Fupdate.json&include_entities%3Dtrue%26oauth_consumer_key%3Dxvz1evFS4wEEPTGEFPHBog%26oauth_nonce%3DkYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1318622958%26oauth_token%3D370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb%26oauth_version%3D1.0%26status%3DHello%2520Ladies%2520%252B%2520Gentlemen%252C%2520a%2520signed%2520OAuth%2520request%2521"
    end

    it "generates the correct Key" do
      end_point = "example.org"
      post_request = create_request(end_point)
      allow(post_request).to receive(:consumer_secret).and_return("kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw")
      allow(post_request).to receive(:token_secret).and_return("LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE")
      expect(post_request.key).to eq("kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw&LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE")
    end

    it "creates the correct hashing signature" do
      end_point = "https://api.twitter.com/1/update.json"
      request_params = {
        "status" => "Hello Ladies + Gentlemen, a signed OAuth request!",
        "include_entities" => "true"
      }
      params = {
        "oauth_consumer_key" => "xvz1evFS4wEEPTGEFPHBog",
        "oauth_nonce" => "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
        "oauth_signature_method" => "HMAC-SHA1",
        "oauth_timestamp" => "1318622958",
        "oauth_token" => "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
        "oauth_version" => "1.0"
      }

      post_request = create_request(end_point)
      allow(post_request).to receive(:consumer_secret).and_return("kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw")
      allow(post_request).to receive(:token_secret).and_return("LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE")
      allow(post_request).to receive(:oauth_headers).and_return(params)
      allow(post_request).to receive(:request_params).and_return(request_params)
      post_request.generate_signature

      expect(post_request.get_param("oauth_signature")).to eq(CGI.escape("tnnArxj06cWHq44gCs1OSKk/jLY="))
    end

    def make_signature(end_point, params, cons_secret) joined_params = CGI.escape(params.sort.map { |values| "#{values[0]}=#{values[1]}" }.join("&"))
      string_base = "POST&#{CGI.escape(end_point)}&#{joined_params}"
      key = "#{cons_secret}&"
      digest = OpenSSL::Digest.new('sha1')
      CGI.escape(Base64.encode64(OpenSSL::HMAC.digest(digest, key, string_base)).strip)
    end
  end

  context "authentication header params" do
    let (:signature_headers) { Twittr::OAuthSignature.new(end_point: "example.org") }
    it "has consumer_key" do
      expect(signature_headers.contains_auth_param?("oauth_consumer_key")).to eq(true)
      expect(signature_headers.get_param("oauth_consumer_key")).to eq("9B8p9gxtml1eiykSHZO23HZRT")

    end

    it "has oauth_token if it is passed in" do
      signature = Twittr::OAuthSignature.new(token: "123", end_point: "example.org")
      expect(signature.get_param("oauth_token")).to eq("123")
    end

    it "has a callback if it gets a callback passed in" do
      signature = Twittr::OAuthSignature.new(callback: "myaddress.com", end_point: "example.org")
      expect(signature.get_param("oauth_callback")).to eq("myaddress.com")
    end

    it "has nonce" do
      allow(SecureRandom).to receive(:hex).and_return("1234")
      expect(signature_headers.contains_auth_param?("oauth_nonce")).to eq(true)
      expect(signature_headers.get_param("oauth_nonce")).to eq("1234")
    end

    it "has a timestamp" do
      expect(signature_headers.contains_auth_param?("oauth_timestamp")).to eq(true)
      expect(signature_headers.get_param("oauth_timestamp")).to be_kind_of(String)
    end

    it "has a oauth_version" do
      expect(signature_headers.contains_auth_param?("oauth_version")).to eq(true)
      expect(signature_headers.get_param("oauth_version")).to eq("1.0")
    end

    it "has a oauth_signature_method" do
      expect(signature_headers.contains_auth_param?("oauth_signature_method")).to eq(true)
      expect(signature_headers.get_param("oauth_signature_method")).to eq("HMAC-SHA1")
    end
  end

  it "sets an auth param" do
    post_request = create_request
    post_request.add_oauth_param("callback", "thisIsCallbackRoute")
    expect(post_request.contains_auth_param?("callback")).to be true
  end

  context "converts a end_point to a valid URI" do
    it "returns a uri" do
      post_request = create_request

      expect(post_request.end_point_to_uri).to be_a URI
    end
  end

  it "has authorization params" do
    post_request = create_request
    expect(post_request).to respond_to(:oauth_headers)
  end

  def create_request(end_point = "www.example.com", consumer_secret = nil, params = {})
    clone_params = params.dup
    Twittr::OAuthSignature.new({end_point: end_point})
  end
end
