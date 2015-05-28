require './lib/twittr/application_controller'
require 'securerandom'
module Twittr
  class SignInController < Twittr::ApplicationController

    configure do
      enable :sessions
    end

    get '/' do
      erb :index
    end

    post '/twitter_login' do
     on_success = lambda {redirect to "https://api.twitter.com/oauth/authenticate?oauth_token=#{session['token']}"}
     Twittr::SignInInteractor.new(host: request.host_with_port, session: session).execute(on_success)
    end

    get '/twitter_callback' do
      oauth_signature = Twittr::OAuthSignature.new(
        end_point: "https://api.twitter.com/oauth/access_token",
        token: session['token']
      )
      requester = Twittr::Requester.new(oauth_signature)
      requester.body = "oauth_verifier=#{params["oauth_verifier"]}"
      requester.make_call
      session['token'] = requester.get_response_param('oauth_token')
      session['secret'] = requester.get_response_param('oauth_token_secret')
      session['screen_name'] = requester.get_response_param('screen_name')
      redirect to "/feed"
    end
  end
end
