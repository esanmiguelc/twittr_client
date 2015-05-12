require 'cgi'
require 'base64'
require 'net/http'
require 'uri' 

module Twittr
  class OAuthPostRequest

    POST = "POST"

    attr_reader :url, :post_request 

    def initialize(url, options = {})
      @url = url
      @consumer_secret = options[:consumer_secret] || ""
      @token_secret = options[:token_secret] || ""
      @oauth_params = options[:oauth_params] || {}
      @post_request = Net::HTTP::Post.new(url)
    end

    def add_oauth_param(key, value)
      oauth_params[key] = value
    end

    def contains_auth_param?(key)
      oauth_params.has_key?(key)
    end

    def generate_signature
      joined_params = CGI.escape(oauth_params.sort.map { |values| "#{values[0]}=#{values[1]}" }.join("&"))
      string_base = "#{POST}&#{CGI.escape(url)}&#{joined_params}"
      key = "#{CGI.escape(consumer_secret)}&#{token_secret}"
      digest = OpenSSL::Digest.new('sha1')
      hmac = OpenSSL::HMAC.digest(digest, key, string_base)
      oauth_params["oauth_signature"] = CGI.escape(Base64.encode64(hmac).strip)
    end
    
    def get_param(key)
      oauth_params[key]
    end

    def oauth_params
      @oauth_params
    end

    def url_to_uri
      URI(url)
    end

    def build_auth_header
      string_params = oauth_params.map { |k,v| "#{k}=#{v}" }.join(", ")
      post_request.add_field("Authorization", "OAuth " + string_params)
    end

    private
    
    attr_reader :consumer_secret, :token_secret

  end
end
