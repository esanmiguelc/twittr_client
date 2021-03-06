require 'sinatra/base'

module Twittr
  class ApplicationController < Sinatra::Base

    set :server, 'webrick'
    
    set :views, File.expand_path('../views', __FILE__)
    set :public_folder, File.expand_path('../assets', __FILE__)
    run! if app_file == $0
  end
end
