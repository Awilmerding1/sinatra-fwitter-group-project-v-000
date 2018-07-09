class TweetsController < ApplicationController

  get '/tweets/new' do 
    if Helpers.is_logged_in?(session)
    @user = Helpers.current_user(session)
    erb :'/tweets/new'
   else 
     flash[:message] = "You must login to view that page."
     redirect to '/'
   end
  end
  
  get '/tweets' do 
    if Helpers.is_logged_in?(session)
    @user = Helpers.current_user(session)
    @tweets = Tweet.all
    erb :'/tweets/index'
    else 
      flash[:message] = "You must login to view that page."
      redirect to '/login'
   end
  end
  
  post '/tweets' do 
    @tweet = Tweet.create(content: params[:content], user_id: session[:id])
    redirect to "/tweets/#{@tweet.id}"
  end
  
  get '/tweets/:id' do 
    if Helpers.is_logged_in?(session)
    @user = Helpers.current_user(session)
    @tweet = Tweet.find(params[:id])
    erb :'/tweets/show'
    else 
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/show'
   end
  end
  
  get '/tweets/:id/edit' do 
    tweet = Tweet.find(params[:id])
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
    if @user.tweets.include?(tweet)
        @tweet = tweet
     erb :'/tweets/edit'
    end
    else 
      flash[:message] = "You may not edit another user's tweet."
     redirect to '/tweets'
    end
    
  end
  
  patch '/tweets/:id' do 
    @tweet = Tweet.find(params[:id])
      @tweet.content = params[:content]
      @tweet.save
      redirect to "/tweets/#{@tweet.id}"
  end
  
  delete '/tweets/:id/delete' do 
	   tweet = Tweet.find(params[:id])
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
      if @user.tweets.include?(tweet)
        @tweet = tweet
        @tweet.delete
        redirect to '/tweets'
      end
    else 
      flash[:message] = "You may not delete another user's tweet."
     redirect to '/tweets'
    end
	end

  

end
