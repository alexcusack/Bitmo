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
  p "[LOG] you're on the index page"
  erb :index
  #login POST /login
  #signup POST /user/new
end

post '/login' do
  if @user = User.authenticate(params[:login])
    session[:user_id] = @user.id
    p "login succeeded"
    redirct "/profile/#{@current_user.username}"
  else
    @errors = @user.errors
    erb :index
  #redirect to /profile/:username
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
    # erb :index
  end
  # @errors = ["Make sure you fill out all the fields"]
  @errors = new_user.errors
  p "FAIL exiting route"
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

  erb :profile
end


## Eventual needs

# get '/transaction/:id' do

#   #from profile on clicking to explore transaction details
# end

# post '/transaction' do

#   #route to run on creating new transaction
# end













