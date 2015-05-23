require 'sinatra/base'
Dir.glob('./lib/twittr/*/*.rb').each { |file| require file }

map('/') { run Twittr::SignInController }
map('/feed') {run Twittr::DashboardController }
