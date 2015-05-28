module Twittr
  class SignInInteractor

    END_POINT = "https://api.twitter.com/oauth/request_token"

    def initialize(options)
      @request = options[:request]
      @session = options[:session]
    end

    def execute(on_success)
      signature = Twittr::OAuthSignature.new(
        callback: "http://#{host}/twitter_callback",
        end_point: END_POINT
      )
      requester = Twittr::Requester.new(signature)
      response_body = requester.make_call
      parser = Twittr::ResponseParser.new(response_body)
      parser.parse
      session['token'] = parser.get_param("oauth_token")
      session['secret'] = parser.get_param("oauth_token_secret")
      on_success.call
    end

    def host
      @request.host_with_port
    end

    def session
      @session
    end
  end
end
