require './lib/twittr/application_controller'
module Twittr
  class SignInController < Twittr::ApplicationController
    get '/' do
      erb :index
    end
  end
end
