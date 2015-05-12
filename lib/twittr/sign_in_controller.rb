require './lib/twittr/application_controller'
module Twittr
  class SignInController < Twittr::ApplicationController
    get '/' do
      erb :index
    end

    post '/twitter_login' do
      url = 'https://api.twitter.com/oauth/request_token' 
      callback = CGI.escape("#{request.host_with_port}/twitter_callback")
      params = {
        "oauth_callback" => callback,
      }
      oauth_post_request = Twittr::OAuthPostRequest.new(url, { oauth_params: params })
      redirect to 'https://api.twitter.com/oauth/authenticate?oauth_token='
    end
  end
end
