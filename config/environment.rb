ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

require 'dotenv'

Dotenv.load

require 'uri'
require 'pathname'
require 'rest-client'
require 'json'
require 'httparty'
require 'nokogiri'

require 'pg'
require 'active_record'
require 'logger'

require 'sinatra'
require "sinatra/reloader" if development?
require 'pry-byebug' if development?
require 'erb'
require 'omniauth-coinbase'
require 'coinbase/wallet'



# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

configure do
  set :root, APP_ROOT.to_path
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET'] || 'this is a secret shhhhh'
  set :views, File.join(Sinatra::Application.root, "app", "views")
end

use OmniAuth::Builder do
  provider :coinbase, ENV["COINBASE_CLIENT_ID"], ENV["COINBASE_CLIENT_SECRET"],
  scope: 'user balance wallet:accounts:read wallet:addresses:read wallet:addresses:create wallet:transactions:send',
  meta: {:send_limit_amount => '100', :send_limit_currency => 'USD', :send_limit_period => 'day'}
end

Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

require APP_ROOT.join('config', 'database')
