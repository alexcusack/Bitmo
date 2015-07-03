# get '/signup-with-coinbase' do
#   redirect coinbase_authorize_url, 303
# end


get '/auth/coinbase/callback' do
  binding.pry
  code = params[:code]
  token = request_coinbase_oauth_token(code)
  login_via_coinbase_token(token)
  redirect to('/')
end


# get '/coinbase-oauth/callback' do
#   binding.pry
#   code = params[:code]
#   token = request_coinbase_oauth_token(code)
#   login_via_coinbase_token(token)
#   redirect to('/')
# end