Dir.glob('./lib/twittr/*.rb').each { |file| require file }
require 'rspec'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

