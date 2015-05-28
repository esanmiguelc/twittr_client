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
      on_success = lambda {redirect to "/feed"}
      Twittr::CallbackInteractor.new(params: params, session: session).execute(on_success)
    end
  end
end
