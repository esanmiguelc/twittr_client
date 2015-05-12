require 'sinatra/base'
module Twittr
  class ApplicationController < Sinatra::Base

   #CONSUMER_KEY = YOUR_APPLICATION_KEY
   #CONSUMER_SECRET = YOUR_APPLICATION_SECRET
    set :server, 'webrick'
    
    set :views, File.expand_path('../views', __FILE__)
    run! if app_file == $0
  end
end
