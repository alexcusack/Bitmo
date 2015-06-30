# require 'constants'
require 'rest-client'
require 'json'


get '/signup-with-venmo' do
 redirect "https://api.venmo.com/v1/oauth/authorize?client_id=#{ENV['VENMO_CLIENT_ID']}&scope=make_payments%20access_profile%20access_email%20access_phone%20access_balance&response_type=code"
end

# get '/venmo-oauth/callback' do
#   p "{LOG} in venmo call back route"
#   binding.pry
#   code = params['code']
#   request_venmo_token(code)
#   # venmo_token = request_venmo_token(code)
#   # current_user.venmo_base_acct
#   redirect '/'
# end



get '/venmo-oauth/callback' do

  AUTHORIZATION_CODE = request['code']
  data = {
      "client_id"=>ENV['VENMO_CLIENT_ID'],
      "client_secret"=>ENV['VENMO_CLIENT_SECRET'],
      "code"=>AUTHORIZATION_CODE
      }
  url = "https://api.venmo.com/v1/oauth/access_token"
  response = RestClient.post url, data
  response_dict = JSON.parse(response.to_str)
  binding.pry
  add_venmo_account_info(response_dict)
  redirect '/'
end