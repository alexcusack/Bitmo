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
  p "top of index"
  if current_user
    p "inside current user"
    p current_user
    redirect "/profile/#{current_user.username}"
  else
    p "inside else"
    erb :index
  end
end

post '/login' do
  p "hitting loggin post route"
  p params
  if @user = User.authenticate(params[:login][:username], params[:login][:password] )
    p "login succeeded"
    session[:user_id] = @user.id
    p "#{current_user.username}"
    redirect "/profile/#{current_user.username}"
  else
    p "hitting else"
    @errors = @user.errors
    erb :index
  end
end


post '/signup' do
  p "hitting sign up route"
  if params[:signup][:password_hash] == params[:verify_password]
    new_user = User.new(params[:signup])
    new_user.password = params[:signup][:password_hash]
    if new_user.save
      p "inside user save"
      session[:user_id] = new_user.id
      redirect "/accounts/setup"
      p "inside errors"
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

  #redirect to profile/:username
end

get '/profile/:username' do
  get_all_user_transactions
  chronological_sort_transactions
  erb :profile
end



# get '/transaction/:id' do

#   #from profile on clicking to explore transaction details
# end

post '/transaction' do
  p "at POST /transaction"
  p params #{"to"=>"", "amount"=>"", "Description"=>"", "pay"=>"Pay"}
  receiver = User.where(username: params[:to]).first
  redirect ("/profile/#{current_user.username}") if receiver == nil
  transaction = Transaction.new(
    # sender_id: "#{current_user.id}",
    # receiver_id: "#{receiver.id}",
    amount: params[:amount],
    description: params[:Description],
    sender_account: "#{current_user.coin_base_acct}",
    receiver_account: "#{receiver.venmo_base_acct}",
    status: "pending"
    )
  if params[:transaction_type] == "Charge"
    transaction.sender_id = "#{receiver.id}"
    transaction.receiver_id = "#{current_user.id}"
  elsif params[:transaction_type] == "Pay"
    p 'in pay route'
    transaction.sender_id = "#{current_user.id}"
    transaction.receiver_id = "#{receiver.id}"
  else
  end
  p transaction
  if transaction.save
    redirect ("profile/#{current_user.username}")
  else
    p transaction.errors
    p "well that didnt work"
  end
end













