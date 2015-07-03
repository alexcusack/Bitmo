get '/' do
  p "{LOG} in index"
  if logged_in?
    p "{LOG} in index redirect"
    redirect "/profile/#{current_user.username}"
  else
    p '{LOG} in else'
    erb :index
  end
end


get '/logout' do
  session[:user_id] = nil
  redirect '/'
end


get '/profile/:username' do
  redirect '/' unless session[:user_id]
  p "{LOG} in profile after redirect"
  binding.pry
  if current_user.username == params[:username]
    p "{LOG} if current_user"
    @user = current_user
    get_all_user_transactions
    get_pending_transaction
    chronological_sort_transactions
    erb :profile
  else
    @user = User.where(username: params[:username]).first
    view_profile_transactions
    erb :profile
  end
end


get '/search' do
  user = User.where(username: params[:query]).first
  if user
    redirect "/profile/#{user.username}"
  else
    @errors = "We didn't find anyone with that username"
    redirect "profile/#{current_user.username}"
  end
end



