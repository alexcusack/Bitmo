get '/auth/coinbase/callback' do
  login_via_coinbase_token
  redirect to('/')
end

get '/signup-with-venmo' do
 redirect "https://api.venmo.com/v1/oauth/authorize?client_id=#{ENV['VENMO_CLIENT_ID']}&scope=make_payments%20access_profile%20access_friends%20access_email%20access_phone%20access_balance&response_type=code"
end

get '/venmo-oauth/callback' do
  data = {
      "client_id"=>ENV['VENMO_CLIENT_ID'],
      "client_secret"=>ENV['VENMO_CLIENT_SECRET'],
      "code"=> request['code']
      }
  url = "https://api.venmo.com/v1/oauth/access_token"
  response = RestClient.post url, data
  response_as_hash = JSON.parse(response.to_str)
  session['venmo_token'] = {
    "access_token"  => response_as_hash['access_token'],
    "expires_in"    => response_as_hash['expires_in'],
    "token_type"    => response_as_hash['token_type'],
    "refresh_token" => response_as_hash['refresh_token'],
    }
  User.add_venmo_account_info(response_as_hash, current_user)
  redirect '/'
end


get '/logout' do
  session[:user_id] = nil
  redirect '/'
end
