get '/signup-with-coinbase' do
  redirect coinbase_authorize_url, 303
end


get '/coinbase-oauth/callback' do
  code = params[:code]
  token = request_coinbase_oauth_token(code)
  binding.pry
  login_via_coinbase_token(token)
  redirect to('/')
end