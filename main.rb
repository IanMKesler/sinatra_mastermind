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
    redirect "/game"
end

get '/game' do
    @game = session[:game]
    @role = session[:role]
    if @game.turn > 12
        session[:winner] = "maker"
        redirect "/end" 
    end
    @hint = @game.turn > 1 ?  @game.hint : [0,0]
    erb @role.to_sym
end

post '/breaker' do
    @pattern = params.values
    @pattern.map! { |value|
        value.to_i
    }
    @game = session[:game]
    @game.round(@pattern)
    if @game.win?
        session[:winner] = "breaker"
        redirect "/end"
    else
        @game.turn +=1 
        redirect "/game"
    end
end

post '/maker' do
    @game = session[:game]
    if @game.turn == 1
        @pattern = params.values
        @pattern.map! { |value|
            value.to_i
        }
        @game.maker.pattern = @pattern
    end 
    @hint = @game.turn > 1 ?  @game.hint : [0,0]
    @game.generate_guess(@hint)
    if @game.win?
        session[:winner] = "breaker"
        redirect "/end"
    else
        @game.turn +=1 
        redirect "/game"
    end
end

post '/reset' do
    session.clear
    redirect "/"
end

get "/end" do
    @session = session
    @game = session[:game]
    erb :end
end

