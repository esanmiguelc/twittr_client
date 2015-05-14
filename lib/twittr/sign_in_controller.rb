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
       oauth_signature = Twittr::OAuthSignature.new(request.host_with_port)
       requester = Twittr::Requester.new(oauth_signature)
       requester.make_call
       session['token'] = requester.get_param("oauth_token")
       session['secret'] = requester.get_param("oauth_token_secret")
       redirect to "https://api.twitter.com/oauth/authenticate?oauth_token=#{session['token']}"
    end

    get '/twitter_callback' do
      url = 'https://api.twitter.com/oauth/access_token' 
      callback = CGI.escape("http://#{request.host_with_port}/twitter_callback")
      auth_params = {
        "oauth_consumer_key" => CONSUMER_KEY,
        "oauth_nonce" => SecureRandom.hex,
        "oauth_signature_method" => "HMAC-SHA1",
        "oauth_token" => session['token'],
        "oauth_timestamp" => Time.now.to_i, 
        "oauth_version" => "1.0"
      }
      oauth_post_request = Twittr::OAuthPostRequest.new(url, {consumer_secret: CONSUMER_SECRET, token_secret: session['secret'],  oauth_params: auth_params })
      oauth_post_request.generate_signature
      oauth_post_request.build_auth_header
      uri = oauth_post_request.url_to_uri
      requester = Twittr::Requester.new(Net::HTTP.new(uri.host, uri.port), oauth_post_request.post_request)
      requester.use_ssl = true
      requester.verify_mode = OpenSSL::SSL::VERIFY_NONE
      requester.body = "oauth_verifier=#{params["oauth_verifier"]}"
      requester.make_call
      session['screen_name'] = requester.get_param('screen_name')
      redirect to "/feed"
    end

    get "/feed" do
      "Username: " + session['screen_name']
    end
  end
end
