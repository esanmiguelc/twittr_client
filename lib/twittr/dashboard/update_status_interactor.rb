module Twittr
  class UpdateStatusInteractor
    END_POINT = 'https://api.twitter.com/1.1/statuses/update.json'

    def initialize(options)
      @params = options[:params]
      @session = options[:session]
    end

    def execute(on_success)
      oauth_signature = Twittr::OAuthSignature.new(
       end_point: "#{END_POINT}?status=#{params['status']}",
       token: session['token'],
       secret: session['secret'])
      requester = Twittr::Requester.new(oauth_signature)
      requester.make_call
      on_success.call
    end

    private

    attr_reader :session, :params
  end
end
