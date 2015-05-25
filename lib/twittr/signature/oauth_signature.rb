require 'base64'
require 'net/http'
require 'uri' 

module Twittr
  class OAuthSignature

    POST = "POST"
    CONSUMER_KEY = "9B8p9gxtml1eiykSHZO23HZRT"
    CONSUMER_SECRET = "4y36UYbf2B6rhyrQljXPp8bNKFcoYD6pkddjTJY9LcTueKcohz" 

    attr_reader :end_point

    def initialize(options = {})
      
      @end_point = options[:end_point]
      @http_method = options[:http_method] || POST
      @token_secret = options[:secret] || ""
      @request_params = options[:request_params] || {}
      oauth_headers["oauth_callback"] = options[:callback] unless options[:callback].nil?
      oauth_headers["oauth_token"] = options[:token] unless options[:token].nil?
    end

    def add_oauth_param(key, value)
      oauth_headers[key] = value
    end
    
    def http_method
      @http_method
    end

    def contains_auth_param?(key)
      oauth_headers.has_key?(key)
    end

    def generate_signature
      parameter_string = request_params.merge(oauth_headers)
      joined_params = parameter_string.sort.map { |values| "#{values[0]}=#{values[1]}" }.join("&")
      digest = OpenSSL::Digest.new('sha1')
      hmac = OpenSSL::HMAC.digest(digest, key, string_base(joined_params))
      oauth_headers["oauth_signature"] = escape(Base64.encode64(hmac).strip)
    end

    def string_base(joined_params)
      string = "#{http_method}&#{escape(end_point)}&#{escape(joined_params)}"
    end

    def key
      "#{escape(consumer_secret)}&#{token_secret}"
    end


    def request_params
      {}
    end

    def get_param(key)
      oauth_headers[key]
    end

    def consumer_secret
      CONSUMER_SECRET
    end

    def oauth_headers
      @oauth_headers ||= {
        "oauth_consumer_key" => CONSUMER_KEY,
        "oauth_nonce" => SecureRandom.hex,
        "oauth_timestamp" => Time.now.to_i.to_s,
        "oauth_signature_method" => "HMAC-SHA1",
        "oauth_version" => "1.0"
      }
    end

    def end_point_to_uri 
      URI(end_point)
    end

    private
    
    def escape(string)
      CGI::escape(string)
    end

    def token_secret
      @token_secret
    end
  end
end
