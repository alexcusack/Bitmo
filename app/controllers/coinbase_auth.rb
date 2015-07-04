get '/auth/coinbase/callback' do
  login_via_coinbase_token
  redirect to('/')
end

