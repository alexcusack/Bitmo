# land on index
# =>  if logged in redirect to home (or render home?)
# else to login/signup page
# =>  sign up post to user/new
# =>  redirect home

# Post route for new transaction
# Takes transaction
# Routes back to profile page

# Get friends
# displays list of friends for the current user


get '/' do
  p "[LOG] top of index"
  if current_user
    p "[LOG] inside current user"
    p current_user
    redirect "/profile/#{current_user.username}"
  else
    p "[LOG] inside else"
    erb :index
  end
end

post '/login' do
  p "[LOG] hitting loggin post route"
  p params
  if @user = User.authenticate(params[:login][:username], params[:login][:password] )
    p "[LOG] login succeeded"
    session[:user_id] = @user.id
    p "[LOG] #{current_user.username}"
    redirect "/profile/#{current_user.username}"
  else
    p "[LOG] hitting else"
    @errors = ["that didn't seem to work... "]
    erb :index
  end
end


post '/signup' do
  p "[LOG] hitting sign up route"
  if params[:signup][:password_hash] == params[:verify_password]
    new_user = User.new(params[:signup])
    new_user.password = params[:signup][:password_hash]
    if new_user.save
      p "[LOG] inside user save"
      session[:user_id] = new_user.id
      redirect "/accounts/setup"
      p "[LOG] inside errors"
    end
  end
  @errors = new_user.errors
  erb :index
end


get '/accounts/setup' do

  erb :account_setup
  #on setup, post to /account/setup/new
  #on skip redirect to profile/:username
end

post '/accounts' do
  #hit route on account linking
  #redirect to profile/:username
end

put '/transaction/:id' do
  p "[LOG] in transaction put route"
  p params #"_method"=>"put", "approval-type"=>"accept", "splat"=>[], "captures"=>["158"], "id"=>"158"}
  transaction = Transaction.find(params[:id])
  p params[:content]
  if params[:content] == 'accept'
    transaction.status = 'completed'
  else params[:content] == 'reject'
    transaction.status = 'rejected'
  end
  transaction.save
  content_type :json
  transaction.to_json
  # redirect "profile/#{current_user.username}"
end




get '/profile/:username' do
  get_all_user_transactions
  get_pending_transaction
  chronological_sort_transactions
  erb :profile
end

get '/search' do

end





post '/transaction' do
  p "[LOG] at POST /transaction"
  receiver = User.where(username: params[:to]).first

  if receiver == nil
    errors = 'user not found'
    content_type :json
    errors.to_json
    status 500
  else
    transaction = Transaction.new(
      amount: params[:amount],
      description: params[:description],
      sender_account: "#{current_user.coin_base_acct}",
      receiver_account: "#{receiver.venmo_base_acct}",
      status: "pending"
      )

    if params[:transaction_type] == "Charge"
      p 'in charge route'
      transaction.sender_id = "#{receiver.id}"
      transaction.receiver_id = "#{current_user.id}"
    elsif params[:transaction_type] == "Pay"
      p 'in pay route'
      transaction.sender_id = "#{current_user.id}"
      transaction.receiver_id = "#{receiver.id}"
    end

    if transaction.save
      p "[LOG] transaction saved. converting to JSON"
      content_type :json
      transaction.to_json
    else
      errors = transaction.errors
      content_type :json
      errors.to_json
      status 500
    end
  end
end

