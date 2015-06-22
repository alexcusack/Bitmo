get '/' do
  if current_user
    redirect "/profile/#{current_user.username}"
  else
    erb :index
  end
end



post '/login' do
  if @user = User.authenticate(params[:login][:username], params[:login][:password] )
    session[:user_id] = @user.id
    redirect "/profile/#{current_user.username}"
  else
    @errors = ["that didn't seem to work... "]
    erb :index
  end
end



post '/signup' do
  if params[:signup][:password_hash] == params[:verify_password]
    new_user = User.new(params[:signup])
    new_user.password = params[:signup][:password_hash]
    if new_user.save
      session[:user_id] = new_user.id
      redirect "/account/setup"
    end
  end
  @errors = new_user.errors
  erb :index
end



get '/logout' do
  session[:user_id] = nil
  redirect '/'
end




get '/account/setup' do
  erb :account_setup
end



put '/transaction/:id' do
  transaction = Transaction.find(params[:id])
  if params[:content] == 'accept'
    transaction.status = 'completed'
  else params[:content] == 'reject'
    transaction.status = 'rejected'
  end
  transaction.save
  content_type :json
  transaction.to_json
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




get '/search' do #search
  user = User.where(username: params[:query]).first
  if user
    redirect "/profile/#{user.username}"
  else
    @errors = "We didn't find anyone with that username"
    redirect "profile/#{current_user.username}"
  end
end




post '/transactions' do
  receiver = User.where(username: params[:to]).first
  transaction = Transaction.new(
    amount: params[:amount],
    description: params[:description],
    sender_id: "#{current_user.id}",
    receiver_id: "#{receiver.id}",
    sender_account: "#{current_user.coin_base_acct}",
    receiver_account: "#{receiver.venmo_base_acct}",
    status: "complete",
    transaction_type: params[:transaction_type]
    )

  if params[:transaction_type] == "Charge"
    transaction.sender_id = "#{receiver.id}"
    transaction.receiver_id = "#{current_user.id}"
    transaction.status = "pending"
  end

  if transaction.save
    content_type :json
    transaction.to_json
  else
    p transaction.errors
    errors = transaction.errors
    content_type :json
    errors.to_json
    status 500
  end
end
