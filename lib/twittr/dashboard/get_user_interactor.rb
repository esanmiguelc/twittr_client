module Twittr
  class GetUserInteractor
    END_POINT = "https://api.twitter.com/1.1/users/show.json"

    attr_reader :session

    def initialize(options)
      @session = options[:session]
    end

    def execute(on_success)
      oauth_signature = Twittr::OAuthSignature.new(
        end_point: "#{END_POINT}?screen_name=#{session['screen_name']}",
        http_method: "GET",
        token: session['token'],
        secret: session['secret']
      )
      requester = Twittr::Requester.new(oauth_signature)
      on_success.call(requester.make_call)
    end
  end
end
