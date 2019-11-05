require_relative "game"
require 'sinatra'
require 'sinatra/reloader' if development?


get '/' do
    @role = params["role"]
    erb :home
end

post '/role' do
    @role = params["role"]
    redirect to("/#{@role}")
end

get '/breaker' do
    "Playing as breaker"
end

get '/maker' do
    "Playing as maker"
end

# get '/maker' do

# end

# get '/breaker' do

# end
# game = Game.new("mastermind")
# game.play