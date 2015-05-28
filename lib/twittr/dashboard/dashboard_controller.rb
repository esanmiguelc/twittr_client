require 'json'
require './lib/twittr/application_controller'

module Twittr
  class DashboardController < Twittr::ApplicationController

    configure do
      enable :sessions
    end

    get "/" do
     if session['screen_name'].nil?
       redirect to "http://#{request.host_with_port}/"
     else
      erb :feed, :layout => false
     end
    end

    get "/home_timeline" do
      oauth_signature = Twittr::OAuthSignature.new(
        end_point: "https://api.twitter.com/1.1/statuses/home_timeline.json",
        http_method: "GET",
        secret: session['secret'],
        token: session['token']
      )
     requester = Twittr::Requester.new(oauth_signature)
     requester.make_call
    end
  end
end
