require './lib/twittr/application_controller'
module Twittr
  class SignInController < Twittr::ApplicationController
    get '/' do
      "hello!"
    end
  end
end
