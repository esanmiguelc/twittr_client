module Twittr
  class Requester

    attr_accessor :params_hash

    def initialize(http_caller, http_method)
      @http_caller = http_caller 
      @http_method = http_method
      @params = ""
      @params_hash = {}
    end

    def make_call
      http_caller.request(http_method)
      @params_hash = split_params(http_caller.body)
    end

    def get_param(key)
      params_hash[key]
    end

    def verify_mode=(mode)
      http_caller.verify_mode = mode
    end

    def use_ssl=(boolean)
      http_caller.use_ssl = boolean
    end

    private

    attr_reader :params, :http_caller, :http_method 

    def split_params(params)
      params.split("&").map { |param| param.split("=") }.to_h
    end
  end
end
