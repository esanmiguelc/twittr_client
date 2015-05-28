module Twittr
  class CallbackInteractor
    END_POINT = "https://api.twitter.com/oauth/access_token"

    attr_reader :session, :params

    def initialize(options)
      @session = options[:session]
      @params = options[:params]
    end

    def execute(on_success)
      oauth_signature = Twittr::OAuthSignature.new(end_point: END_POINT,
                                 token: session['token'])
      requester = Twittr::Requester.new(oauth_signature).tap do |request|
        request.body = "oauth_verifier=#{params["oauth_verifier"]}"
      end
      parser = Twittr::ResponseParser.new(requester.make_call)
      parser.parse
      session['token'] = parser.get_param("oauth_token")
      session['secret'] = parser.get_param("oauth_token_secret")
      session['screen_name'] = parser.get_param("screen_name")
      p session
      on_success.call 
    end
  end
end
