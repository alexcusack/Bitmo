get '/signup-with-venmo' do
 redirect "https://api.venmo.com/v1/oauth/authorize?client_id=#{ENV['VENMO_CLIENT_ID']}&scope=make_payments%20access_profile%20access_friends%20access_email%20access_phone%20access_balance&response_type=code"
end


get '/venmo-oauth/callback' do
  code = request['code']
  data = {
      "client_id"=>ENV['VENMO_CLIENT_ID'],
      "client_secret"=>ENV['VENMO_CLIENT_SECRET'],
      "code"=> code
      }
  url = "https://api.venmo.com/v1/oauth/access_token"
  response = RestClient.post url, data
  reponse_as_hash = JSON.parse(response.to_str)
  add_venmo_account_info(reponse_as_hash)
  session['venmo_token'] = reponse_as_hash['access_token']
  get_friends
  redirect '/'
end

#get venmo friends
get '/profile/:username/friends' do
  # url = "https://api.venmo.com/v1/users/#{current_user.venmo_account}/friends?access_token=#{session['venmo_token']}"
  # response = RestClient.get url
  # response_as_hash = JSON.parse(response.to_str)
end
