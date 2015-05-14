require 'net/http'

module Twittr
  class Requester

    attr_accessor :response_params

    def initialize(options)
      @oauth_signature = options[:oauth_signature]
      @response_params = {}
    end

    def make_call
     request.add_field("Authorization", string_auth_values)
     res = http_caller.request(request)
     @response_params = split_response_params(res.body)
    end

    def http_caller
      @http_caller ||= Net::HTTP.new(uri.host, uri.port)
    end

    def uri
      oauth_signature.url_to_uri
    end

    def request
      @request ||= Net::HTTP::Post.new(oauth_signature.url)
    end

    def get_param(key)
      params_hash[key]
    end

    def verify_mode=(mode)
      http_caller.verify_mode = mode
    end

    def string_auth_values
      oauth_signature.oauth_headers.map { |k,v| "#{k}=#{v}" }.join(", ")
    end

    def use_ssl=(boolean)
      http_caller.use_ssl = boolean
    end

    def body=(params)
      request.body = params
    end

    private

    attr_reader :oauth_signature

    def split_response_params(params)
      params.split("&").map { |param| param.split("=") }.to_h
    end
  end
end
