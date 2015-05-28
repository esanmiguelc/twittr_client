require 'cgi'
module Twittr
  class Requester

    attr_accessor :response_params

    def initialize(signature)
      @oauth_signature = signature 
    end

    def make_call
      oauth_signature.generate_signature
      request.add_field("Authorization", string_auth_values)
      response = http_caller.request(request).tap do |response|
        @response_params = split_response_params(response.body)
      end
      response.body
    end

    def http_caller
      @http_caller ||= Net::HTTP.new(uri.host, uri.port)
      @http_caller.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @http_caller.use_ssl = true
      @http_caller
    end

    def uri
      oauth_signature.end_point_to_uri
    end

    def request
      if (oauth_signature.http_method == "GET")
        @request ||= Net::HTTP::Get.new(oauth_signature.end_point)
      else
        @request ||= Net::HTTP::Post.new(oauth_signature.end_point)
      end
    end

    def string_auth_values
      "OAuth " << oauth_signature.oauth_headers.map { |k,v| "#{k}=#{v}" }.join(", ")
    end

    def get_response_param(param)
      response_params[param]
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
