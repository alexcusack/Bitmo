get '/' do
  if logged_in?
    redirect "/profile/#{current_user.username}"
  else
    erb :index
  end
end

get '/playground' do
  account = coinbase_client.primary_account
  binding.pry
  # begin
  #   account.send(to: 'cusackpeter@gmail.com', amount: '1', currency: "USD")
  # rescue Coinbase::Client::TwoFactorRequiredError
  #   # Show 2FA dialog to user and collect 2FA token
  #   # Re-try call with `two_factor_token` param
  #   binding.pry
  #   account.send(to: 'cusackpeter@gmail.com', amount: '1', currency: "USD", two_factor_token: "123456")
  # end
end



get '/logout' do
  session[:user_id] = nil
  redirect '/'
end


get '/profile/:username' do
  redirect '/' unless session[:user_id]
  if current_user.username == params[:username]
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



