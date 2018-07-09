require 'sinatra/base'
require 'rack-flash'

class UsersController < ApplicationController
  
  use Rack::Flash

 get '/signup' do 
   if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
       @tweets = Tweet.all
      redirect '/tweets'
    else
      erb :'/users/signup'
    end
 end
 
 post '/signup' do 
   if !User.find_by(username: params[:username]) && params[:password] != "" && params[:email] != "" && params[:username] != ""
   @user = User.create(username: params[:username], email: params[:email], password: params[:password])
   session[:user_id] = @user.id 
   @tweets = Tweet.all
   redirect '/tweets'
  else 
  flash[:message] = "Please create an account."
    redirect '/signup'
  end
 end
 
  get '/login' do 
     if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
      @tweets = Tweet.all
      redirect '/tweets'
    else
      erb :'/users/login'
    end
  end
  
  post '/login' do 
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
		  session[:user_id] = @user.id 
		   @tweets = Tweet.all
		  redirect '/tweets'
    else 
       flash[:message] = "The username or password is incorrect."
       redirect '/login'
    end
  end
  
  get '/logout' do 
    session.clear
    redirect '/login'
  end
 
  
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    @current_user = Helpers.current_user(session)
    erb :"users/show"
  end


end
