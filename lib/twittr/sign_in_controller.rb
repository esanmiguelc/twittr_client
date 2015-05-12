require './lib/twittr/application_controller'
require 'securerandom'
module Twittr
  class SignInController < Twittr::ApplicationController
    get '/' do
      erb :index
    end

    post '/twitter_login' do
      url = 'https://api.twitter.com/oauth/request_token' 
      callback = CGI.escape("http://#{request.host_with_port}/twitter_callback")
      auth_params = {
        "oauth_callback" => callback,
        "oauth_consumer_key" => CONSUMER_KEY,
        "oauth_nonce" => SecureRandom.hex,
        "oauth_signature_method" => "HMAC_SHA1",
        "oauth_timestamp" => Time.now.to_i, 
        "oauth_version" => "1.0"
      }
      oauth_post_request = Twittr::OAuthPostRequest.new(url, {consumer_secret: CONSUMER_SECRET,  oauth_params: auth_params })
      oauth_post_request.generate_signature
      oauth_post_request.build_auth_header
      uri = oauth_post_request.url_to_uri
      requester = Twittr::Requester.new(Net::HTTP.new(uri.host, uri.port), oauth_post_request.post_request)
      requester.use_ssl = true
      requester.verify_mode = OpenSSL::SSL::VERIFY_NONE
      requester.make_call
      redirect to 'https://api.twitter.com/oauth/authenticate?oauth_token='
    end

    get '/twitter_callback' do
    end
  end
end
