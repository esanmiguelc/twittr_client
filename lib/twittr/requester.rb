module Twittr
  class Requester

    attr_accessor :params_hash

    def initialize(http_caller)
      @http_caller = http_caller 
      @params = ""
      @params_hash = {}
    end

    def make_call
      @params_hash = split_params(http_caller.body)
    end

    def get_param(key)
      params_hash[key]
    end

    private

    attr_reader :params, :http_caller 

    def split_params(params)
      params.split("&").map { |param| param.split("=") }.to_h
    end
  end
end
