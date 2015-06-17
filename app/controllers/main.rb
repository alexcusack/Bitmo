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

  #redirect to /profile/:username
end


post '/signup' do

  #redirect to /setup
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













