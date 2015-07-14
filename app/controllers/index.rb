get '/' do
  if logged_in?
    redirect "/profile/#{current_user.username}"
  else
    erb :index
  end
end


get '/profile/:username' do
  redirect '/' if current_user == nil
  if current_user.username == params[:username]
    @user = current_user
    get_all_user_transactions
    get_pending_transaction
    chronological_sort_transactions
    erb :profile
  else
    @user = User.where(username: params[:username]).first
    if !@user
      @errors =  "**We couldn't find a user with that username**"
      @user = current_user
    end
    view_profile_transactions
    erb :profile
  end
end


get '/listener' do
 return params[:venmo_challenge]
end



get '/search' do
  user = User.where(email: params[:query]).first
  if user
    redirect "/profile/#{user.username}"
  else
    redirect "/profile/#{current_user.username}"
  end
end