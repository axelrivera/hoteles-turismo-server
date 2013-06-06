require 'sinatra'
require 'json'
require 'httparty'
require './helpers'

before do
  content_type 'application/json'
end

get '/hotels.json' do
  { hotels: hotels }.to_json
end

get '/tourist-zones.json' do
  { tourist_zones: zones }.to_json
end