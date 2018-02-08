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

  get '/login' do
    if logged_in?
      redirect to '/recipes'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/recipes'
    else
      redirect '/login'
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

  post '/recipes' do
    if logged_in?
      @recipe = Recipe.create(params[:recipe])
      @recipe.user_id = session[:user_id]
      @recipe.save
      @ingredients = params[:ingredients]
      @ingredients.each do |ingredient_hash|
        if !ingredient_hash["amount"].empty? && !ingredient_hash["name"].empty?
          @recipe.ingredients << Ingredient.create(ingredient_hash)
          @recipe.save
        end
      end
      redirect to "/recipes/#{@recipe.id}"
    else
      redirect '/login'
    end
  end

  get '/recipes/:id' do
    if logged_in?
      @recipe = Recipe.find_by_id(params[:id])
      erb :"/recipes/show"
    else
      redirect "/login"
    end
  end



end
