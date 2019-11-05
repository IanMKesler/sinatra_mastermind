require_relative "game"
require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

get '/' do
    @session = session
    @role = params["role"]
    erb :home
end

post '/role' do
    @role = params["role"]
    session[:role] = @role
    session[:game] = Game.new("mastermind", @role)
    @game = session[:game]
    @game.generate_secret if @role == "breaker"
    redirect to("/#{@role}")
end

get '/breaker' do
    @game = session[:game]
    redirect to("/lose") if @game.turn > 12
    @hint = @game.hint if @game.turn > 1
    erb :breaker
end

post '/breaker' do
    @pattern = params.values
    @pattern.map! { |value|
        value.to_i
    }
    @game = session[:game]
    @game.round(@pattern)
    if @game.win?
        redirect "/win"
    else
        @game.turn +=1 
        redirect "/breaker"
    end
end

get '/maker' do
    erb :maker
end

post '/reset' do
    session.clear
    redirect to("/")
end

get "/win" do
    "You won!"
end

get "/lose" do
    "You lost!, better luck next time."
end

