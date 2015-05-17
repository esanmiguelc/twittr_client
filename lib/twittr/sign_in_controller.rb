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
      oauth_signature = Twittr::OAuthSignature.new(
        callback: "http://#{request.host_with_port}/twitter_callback", 
        end_point: "https://api.twitter.com/oauth/request_token"
      )
       requester = Twittr::Requester.new(oauth_signature)
       requester.make_call
       session['token'] = requester.get_response_param("oauth_token")
       session['secret'] = requester.get_response_param("oauth_token_secret")

       redirect to "https://api.twitter.com/oauth/authenticate?oauth_token=#{session['token']}"
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

    get "/feed" do
      oauth_signature = Twittr::OAuthSignature.new(
        method: "GET",
        end_point: "https://api.twitter.com/1.1/statuses/home_timeline.json",
        secret: session['secret'],
        token: session['token'])
      requester = Twittr::Requester.new(oauth_signature)
      requester.make_call
      requester.body
    end
  end
end
