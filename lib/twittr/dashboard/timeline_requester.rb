require './lib/twittr/sign_in/requester'

module Twittr
  class TimelineRequester < Twittr::Requester

    def make_call
      oauth_signature.generate_signature
      request.add_field("Authorization", string_auth_values)
      res = http_caller.request(request)
      res.body
    end
  end
end
