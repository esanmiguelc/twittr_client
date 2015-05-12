require 'sinatra/base'
module Twittr
  class ApplicationController < Sinatra::Base

   CONSUMER_KEY = "9B8p9gxtml1eiykSHZO23HZRT"
   CONSUMER_SECRET = "4y36UYbf2B6rhyrQljXPp8bNKFcoYD6pkddjTJY9LcTueKcohz" 

    set :server, 'webrick'
    
    set :views, File.expand_path('../views', __FILE__)
    run! if app_file == $0
  end
end
