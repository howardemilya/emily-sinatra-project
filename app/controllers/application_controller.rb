require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "fwitter_secret"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

  get '/' do
    erb :index
  end

  get '/signup' do

    erb :'/users/create_account'
  end

  post '/signup' do
    if !params[:username].empty? && !params[:email].empty? && !params[:password].empty?
      @user = User.create(params)
      session[:user_id] = @user.id
      redirect to '/recipes'
    else
      redirect to "/signup"
    end
  end

  get '/recipes' do
    if logged_in?
      @user = User.find_by_id(session[:user_id])
      erb :'/recipes/all'
    else
      redirect to '/login'
    end
  end

  get '/recipes/new' do
    if logged_in?
      @user = User.find_by_id(session[:user_id])
      erb :'/recipes/new'
    else
      redirect '/login'
    end
  end



end
