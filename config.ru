require 'sinatra/base'
require './lib/twittr/response_parser'
Dir.glob('./lib/twittr/*/*.rb').each { |file| require file }

map('/') { run Twittr::SignInController }
map('/feed') {run Twittr::DashboardController }
