require 'sinatra/base'
module Twittr
  class ApplicationController < Sinatra::Base
    set :server, 'webrick'
    
    run! if app_file == $0
  end

end
