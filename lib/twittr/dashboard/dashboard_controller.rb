require 'json'
require './lib/twittr/application_controller'

module Twittr
  class DashboardController < Twittr::ApplicationController

    configure do
      enable :sessions
    end

    get "/" do
      on_success = lambda { redirect to "http://#{request.host_with_port}/"}
      on_fail = lambda { erb :feed, :layout => false }
      Twittr::AuthorizationInteractor.new(session: session).execute(on_success, on_fail)
    end

    post "/update_status" do
      on_success = lambda { true }
      Twittr::UpdateStatusInteractor.new(params: params, session: session).execute(on_success)
    end

    get "/twitter_user" do
      on_success = lambda { |json| json }
      Twittr::GetUserInteractor.new(session: session).execute(on_success)
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
