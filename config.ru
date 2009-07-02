require 'rubygems'
# require 'vendor/sinatra/lib/sinatra/base.rb'
require 'sinatra'


set :environment, ENV['RACK_ENV']

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production
)


require 'server.rb'
run Sinatra.application